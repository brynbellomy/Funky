
require 'xcodeproj'


def loadProject(name:)
    return Xcodeproj::Project.open("#{Dir.pwd}/#{name}.xcodeproj")
end

def infoPlist()
    """
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>org.illumntr.$(PRODUCT_NAME:rfc1034identifier)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2015 bryn austin bellomy. All rights reserved.</string>
    <key>NSPrincipalClass</key>
    <string></string>
</dict>
</plist>
"""
end


module Xcodeproj

    class Project

        def target(name:)
            matches = targets.select { |t| t.name == name }
            return nil if matches.count <= 0
            return matches.first
        end

        def group(name:)
            matches = groups.select { |g| g.name == name }
            return nil if matches.count <= 0
            return matches.first
        end

        def fileref(path:)
            matches = files.select { |f| f.path == path }
            return nil if matches.count <= 0
            return matches.first
        end

        def ensureFileRef(path:)
            # reference_for_path(target.project.path)
            return fileref(path:path) || new_file(path)
        end

        def ensureTarget(name, type, platform)
            return target(name:name) || new_target(type, name, platform)
        end

        def ensureGroup(name:)
            return group(name:name) || new_group(name)
        end

        def addSubmodule(name, globs:, requires: [])

            #
            # GROUPS
            #
            submoduleGroup  = ensureGroup(name: 'vendor').ensureGroup(name: name)

            filerefs = globs.map { |fp| Dir.glob(fp) }
                            .flatten
                            .map { |fp| ensureFileRef(path: fp) }

            #
            # TARGETS
            #

            submoduleTarget = ensureTarget(name, :framework, :osx)

            # file references
            ensureTargetHasFilerefs target: submoduleTarget,
                                  filerefs: filerefs

            filerefs.each { |ref| ref.move(submoduleGroup) }

            # build settings
            submoduleTarget.build_configurations.each { |bc| bc.build_settings['DEFINES_MODULE'] = 'YES' }

            # dependencies (make the main target of the project dependent upon the new submodule target)
            targets.first.add_dependency(submoduleTarget)

            # targets.each do |tgt|

            #     ensureLibraryIsLinked project: self,
            #                           target: tgt,
            #                           path:
            # end

            # Info.plist
            writeInfoPlist path:"vendor/#{name}"
        end

        def writeInfoPlist(path:)
            File.write("#{path}/Info.plist", infoPlist())
            # File.open("#{path}/Info.plist", 'w') { |file| file.write }
        end
    end
end

def ensureTargetHasFilerefs(target:, filerefs:)
    refs = filerefs.select { |ref|
        index = target.source_build_phase.files.index { |file| file.file_ref.path == ref.path }
        puts "index = #{index}"
        index == nil
    }

    puts "FILE REFS = #{refs.inspect}"
    target.add_file_references(refs) if refs.count > 0
    return target
end

def ensureLibraryIsLinked(project:, target:, path:)
    fileref = project.frameworks_group.find_file_by_path(path) || project.frameworks_group.new_file(path, :sdk_root)

    target.frameworks_build_phase.add_file_reference(fileref, true)
end


module Xcodeproj
    class Project
        module Object
            class PBXGroup
                def group(name:)
                    matches = groups.select { |g| g.name == name }
                    return nil if matches.count <= 0
                    return matches.first
                end

                def fileref(path:)
                    matches = files.select { |f| f != nil }
                                   .select { |f| f.path == path }

                    return nil if matches.count <= 0
                    return matches.first
                end

                def ensureGroup(name:)
                    return group(name:name) || new_group(name)
                end

                # def ensureFileRef(path:)
                #     return fileref(path:path) || new_file(path)
                # end
            end
        end
    end
end


