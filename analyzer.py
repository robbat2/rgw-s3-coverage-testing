#! /usr/bin/env python
"""
Coverage analyzer for s3-tests: 
(1) Parses coverage.json output after running specific test(s)
(2) Identifies source files and function signatures in Boto SDK where new tests are to written.

Usage:
analyzer.py -i <path to directory which contains coverage.json> -t <s3test-command>
"""
import getopt
import json
import sys
import ast
import tokenize
import intervaltree
import re

def _compute_interval(node):
    """Compute interval for function signature"""
    min_lineno = node.lineno
    max_lineno = node.lineno
    for node in ast.walk(node):
        if hasattr(node, "lineno"):
            min_lineno = min(min_lineno, node.lineno)
            max_lineno = max(max_lineno, node.lineno)
    return (min_lineno, max_lineno + 1)

def file_to_tree(filename):
    """
    Generates interval tree of function signatures 
    from Boto SDK source-filename
    """
    with tokenize.open(filename) as f:
        parsed = ast.parse(f.read(), filename=filename)
    tree = intervaltree.IntervalTree()
    for node in ast.walk(parsed):
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            start, end = _compute_interval(node)
            tree[start:end] = node
    return tree

def getNode(file_tree,line_no):
  """Get the Node specific to the missing line_no in the file_tree"""
  matches = file_tree[line_no]
  prefix = ''
  if matches:
    node = min(matches, key=lambda i: i.length())
    if isinstance(node.data, ast.ClassDef):
      prefix = 'CLASS:'
    if isinstance(node.data, ast.FunctionDef):
      prefix = 'FUNCTION:'
  return prefix,node

def get_coverage_json(input_file_path):
  """Get coverage.json file from the coverage-output"""
  json_path = f"/{input_file_path}/coverage.json"
  f = open(json_path)
  return json.load(f)

def get_filenames_from_coverage(input_file_path):
  """Parses and gets all source filenames from coverage.json"""
  filenames = []
  coverage_data = get_coverage_json(input_file_path)
  for key in coverage_data["files"].keys():
    if re.search("/s3-tests/virtualenv/lib/python3.6/site-packages/boto/s3", key) or re.search("/s3-tests/virtualenv/lib/python3.6/site-packages/boto3/s3", key):
      filenames.append(key)
  return filenames

def coverage_analyzer(input_file_path,output_file_path,test_name):
  """Analyses the coverage.json and outputs functions signatures for each source-file"""
  filenames = get_filenames_from_coverage(input_file_path)
  coverage_json = get_coverage_json(input_file_path)
  f = open(output_file_path,"w")
  f.write(f"> TEST: {test_name}\n\n")
  f.write("> Function definitions lacking coverage in BOTO SDK for the current TEST:\n\n")
  for i,filename in enumerate(filenames):
    missing = []
    filename_cov_json = coverage_json["files"][filename]
    file_tree = file_to_tree(filename)
    f.write(f"({i+1}) "+ "URL:"+filename+"\n")
    for line_no in filename_cov_json["missing_lines"]:
        prefix,node = getNode(file_tree,line_no)
        if(prefix+node.data.name not in missing):
            missing.append(prefix+node.data.name)
            f.write(prefix+node.data.name+"\n")
    f.write("\n\n")

def main(argv):
    """Get Command Line Arguments"""
    input_file_path = ''
    output_file_path = '/s3-tests/cov-analysis.txt'
    test_name = ''
    try:
        opts, _ = getopt.getopt(
            argv, "hi:t:", ["ifile=", "test="])
    except getopt.GetoptError:
        print(__doc__)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(__doc__)
            sys.exit()
        if opt in ("-i", "--ifile"):
            input_file_path = arg
        elif opt in ("-t", "--test"):
            test_name = arg
    coverage_analyzer(input_file_path,output_file_path,test_name)
if __name__ == "__main__":
    main(sys.argv[1:])