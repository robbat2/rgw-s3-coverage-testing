#! /usr/bin/env python
import getopt
import json
import sys
import ast
import tokenize
import intervaltree
import re

def _compute_interval(node):
    min_lineno = node.lineno
    max_lineno = node.lineno
    for node in ast.walk(node):
        if hasattr(node, "lineno"):
            min_lineno = min(min_lineno, node.lineno)
            max_lineno = max(max_lineno, node.lineno)
    return (min_lineno, max_lineno + 1)

def file_to_tree(filename):
    """Generates interval tree from filename"""
    with tokenize.open(filename) as f:
        parsed = ast.parse(f.read(), filename=filename)
    tree = intervaltree.IntervalTree()
    for node in ast.walk(parsed):
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            start, end = _compute_interval(node)
            tree[start:end] = node
    return tree

def getNode(file_tree,line_no):
  matches = file_tree[line_no]
  prefix = ''
  if matches:
    node = min(matches, key=lambda i: i.length())
    if isinstance(node, ast.FunctionDef):
      prefix = 'CLASS:'
    if isinstance(node, ast.ClassDef):
      prefix = 'FUNCTION:'
  return prefix,node

def get_coverage_json(input_file_path):
  json_path = f"/{input_file_path}/coverage.json"
  f = open(json_path)
  return json.load(f)

def get_filenames_from_coverage(input_file_path):
  filenames = []
  coverage_data = get_coverage_json(input_file_path)
  for key in coverage_data["files"].keys():
    if re.search("/s3-tests/virtualenv/lib/python3.6/site-packages/boto/s3", key) or re.search("/s3-tests/virtualenv/lib/python3.6/site-packages/boto3/s3", key):
      filenames.append(key)
  return filenames

def coverage_analyzer(input_file_path):
  filenames = get_filenames_from_coverage(input_file_path)
  coverage_json = get_coverage_json(input_file_path)
  print("Function definitions lacking coverage in BOTO SDK:\n\n")
  for i,filename in enumerate(filenames):
    missing = []
    filename_cov_json = coverage_json["files"][filename]
    file_tree = file_to_tree(filename)
    print(f"{i+1} "+ "URL:"+filename)
    for line_no in filename_cov_json["missing_lines"]:
        prefix,node = getNode(file_tree,line_no)
        if(prefix+node.data.name not in missing):
            missing.append(prefix+node.data.name)
            print(prefix+node.data.name)
    print("\n\n")


def main(argv):
    """Get Command Line Arguments"""
    input_file_path = ''
    try:
        opts, _ = getopt.getopt(
            argv, "hi:o:f:", ["ifile=", "ofile=", "format="])
    except getopt.GetoptError:
        print(__doc__)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(__doc__)
            sys.exit()
        if opt in ("-i", "--ifile"):
            input_file_path = arg
    coverage_analyzer(input_file_path)
if __name__ == "__main__":
    main(sys.argv[1:])