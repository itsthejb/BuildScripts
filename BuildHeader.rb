#!/usr/bin/env ruby

require 'date'

if ARGV.count != 4
  abort('Usage: ruby $PROJECT_DIR/Scripts/BuildHeader.rb $PROJECT_NAME $PROJECT_DIR $BUILT_PRODUCTS_DIR origin')
end

# Commandline args
project_name        = ARGV[0]
project_dir         = ARGV[1]
built_products_dir  = ARGV[2]
origin              = ARGV[3]

# Script assumes that the  $origin repo is ' $origin'. If not, change here
$prefix = project_name.upcase
filename = project_name + 'Build.h'
path = built_products_dir + '/' + filename

# TODO: use Grit
git_sha = %x[ #{'git --git-dir="' + project_dir + '/.git" --work-tree="' + project_dir + '" rev-parse --short HEAD'} ].strip
git_branch = %x[ #{'git --git-dir="' + project_dir + '/.git" --work-tree="' + project_dir + '" symbolic-ref --short -q HEAD'} ].strip

if git_branch.length == 0
  git_branch = %x[ #{'git rev-parse HEAD | git branch -a --contains | grep remotes | sed -e "s/.*remotes.' +  $origin + './/"'} ].strip
end

# We may have multiple branches, so we always create a set
git_branch = '[NSSet setWithArray:@[ @"' + Array(git_branch).join('", @"') + '" ]]'

if Dir.exists?(path)
  Dir.delete(path)
end

def buildDefine(name, value, quote)
  quote = (quote ? '@"' : '')
  return "\n#define " + $prefix + '_' + name + ' ' + quote + value + quote
end

header_text = "//\n// " + filename + "\n//\n" +
buildDefine('BUILD_SHA', git_sha, true) +
buildDefine('BUILD_SHA_BRANCHES', git_branch, false) +
buildDefine('BUILD_DATE', Date.today.to_s, true) +
buildDefine('BUILD_DATE_TIME', Time.now.to_s, true) +
buildDefine('BUILD_USER', %x[git config user.name].strip, true) + "\n"

# Write results
File.open(path, 'w') { |file| file.write(header_text) }
