require 'nokogiri'
require 'base64'
require 'zammad/szpm/version'

# General Zammad class, for later/other purposes maybe. Should handle more Zammad related stuff
class Zammad
  # Handles all SZPM and ZPM related stuff
  class SZPM

    attr_reader :szpm
    attr_reader :structure

    # Creates an instance based on a given SZPM file path.
    #
    # @param szpm_file [String] the path to the SZPM file.
    # @return (see #parse)
    def initialize(szpm_file)

      @szpm_file = szpm_file

      parse
    end

    # Adds a new version and the change_log to the SZPM file.
    #
    # @param version [String] the version number.
    # @param change_log [String] the change_log.
    # @return (see #parse)
    def version(version, change_log)
      parse

      # change version
      @structure['version'] = version

      # append change_log
      @structure['change_log'] ||= []

      # remove tabs from change_log
      change_log.gsub!(/\t/, '  ')

      # strip whitespaces
      change_log.strip!

      # append entry
      @structure['change_log'].push({
                                     'version' => version,
                                     'date'    => Time.zone.now,
                                     'content' => change_log
                                   })

      store
    end

    # Adds the buildhost and builddate to the SZPM file.
    #
    # @param build_host [String] build host on which the ZPM file was created.
    # @return (see #parse)
    def add_build_information(build_host)
      parse

      # add buildhost
      @structure['buildhost'] = build_host
      # add builddate
      @structure['builddate'] = Time.zone.now

      store
    end

    # Adds a new file to the filelist of the SZPM file.
    #
    # @param location [String] the file location.
    # @param permission [Integer] the permissions with which the files should get created.
    # @return (see #parse)
    def add_file( location, permission = 644 )
      parse

      update = true
      @structure['files'].each { |file|

        next if file['location'] != location
        next if file['permission'] != permission

        update = false

        break
      }
      return if !update

      @structure['files'].push({
                                 'location'   => location,
                                 'permission' => permission,
                               })

      store
    end

    # Stores the changes to the SZPM file.
    #
    # @return (see #parse)
    def store

      File.open(@szpm_file, 'w') { |file|
        file.write( JSON.pretty_generate(@structure) )
      }

      parse
    end

    # Parses the given SZPM file.
    #
    # @return [Hash] the parsed SZPM structure.
    def parse

      szpm_read_handle = File.open(@szpm_file)
      @szpm            = szpm_read_handle.read
      szpm_read_handle.close

      @structure = JSON.parse( @szpm )
    end

    # Creates an ZPM string out of the SZPM file.
    #
    # @return [String] ZPM JSON content with Base64 encoded files.
    def zpm
      zpm = parse

      folder = File.dirname(@szpm_file)

      zpm['files'].collect! { |file|

        file_location = file['location']
        file_handle   = File.open("#{folder}/#{file_location}", 'r')
        file_content  = file_handle.read
        file_handle.close

        file['encode']  = 'base64'
        file['content'] = Base64.strict_encode64( file_content )

        file
      }

      JSON.pretty_generate(zpm)
    end
  end
end
