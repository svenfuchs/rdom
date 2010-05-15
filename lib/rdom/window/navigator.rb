module RDom
  class Window
    class Navigator
      attr_reader :appCodeName, :appName, :appVersion, :buildID, :cookieEnabled,
        :language, :mimeTypes, :onLine, :oscpu, :plattform, :plugins, :product,
        :productSub, :securityPolicy, :userAgent, :vendor, :vendorSub,
        :javaEnabled, :mozIsLocallyAvailable, :taintEnabled
        
      def initialize
        @appCodeName    = ''    # the internal "code" name of the current browser.
        @appName        = ''    # the official name of the browser.
        @appVersion     = ''    # the version of the browser as a string.
        @buildID        = ''    # the build identifier of the browser (e.g. "2006090803")
        @cookieEnabled  = true  # a boolean indicating whether cookies are enabled in the browser or not.
        @language       = ''    # a string representing the language version of the browser.
        @mimeTypes      = ''    # a list of the MIME types supported by the browser.
        @onLine         = true  # a boolean indicating whether the browser is working online.
        @oscpu          = ''    # a string that represents the current operating system.
        @platform       = ''    # a string representing the platform of the browser.
        @plugins        = []    # an array of the plugins installed in the browser.
        @product        = ''    # the product name of the current browser. (e.g. "Gecko")
        @productSub     = ''    # the build number of the current browser (e.g. "20060909")
        @securityPolicy = ''    # an empty string. In Netscape 4.7x, "US & CA domestic policy" or "Export policy".
        @userAgent      = ''    # the user agent string for the current browser.
        @vendor         = ''    # the vendor name of the current browser (e.g. "Netscape6")
        @vendorSub      = ''    # the vendor version number (e.g. "6.1")
        @javaEnabled    = true  # Indicates whether the host browser is Java-enabled or not.
        @taintEnabled   = false # JavaScript taint/untaint functions removed in JavaScript 1.2
        @mozIsLocallyAvailable = true # Lets code check to see if the document at a given URI is available without using the network.
      end

      def preference(name, value)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#preference"))
      end

      def registerContentHandler(mimeType, uri, title)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#registerContentHandler"))
      end

      def registerProtocolHandler(protocol, uri, title)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#registerProtocolHandler"))
      end
    end
  end
end