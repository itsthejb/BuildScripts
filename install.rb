#!/usr/bin/env ruby

require 'xcodeproj'

if ARGV.count != 1
  puts "Usage: " + File.basename(__FILE__) + " <xcode project folder>"
  exit 1
end

projectFolder = ARGV[0]
Dir.chdir(projectFolder)

projects = Dir.entries(".").select { |file| file.end_with?('.xcodeproj') }

if projects.count != 1
  puts "None, or more than one .xcodeproj in directory"
  exit 1
end

project = Xcodeproj::Project.open(projects.first)
main_target = project.targets.first

puts main_target.build_phases

exit 0

phase = main_target.new_shell_script_build_phase("Name of your Phase")
phase.shell_script = "Test script"
project.save()

