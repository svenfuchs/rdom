module RDom
  class Window
    class Navigator
      properties :appCodeName, :appName, :appVersion, :buildID, :cookieEnabled,
        :language, :mimeTypes, :onLine, :oscpu, :platform, :plugins, :product,
        :productSub, :securityPolicy, :userAgent, :vendor, :vendorSub,
        :javaEnabled, :mozIsLocallyAvailable, :taintEnabled

      def initialize
        self.appCodeName    = ''    # the internal "code" name of the current browser.
        self.appName        = ''    # the official name of the browser.
        self.appVersion     = ''    # the version of the browser as a string.
        self.buildID        = ''    # the build identifier of the browser (e.g. "2006090803")
        self.cookieEnabled  = true  # a boolean indicating whether cookies are enabled in the browser or not.
        self.language       = ''    # a string representing the language version of the browser.
        self.mimeTypes      = ''    # a list of the MIME types supported by the browser.
        self.onLine         = true  # a boolean indicating whether the browser is working online.
        self.oscpu          = ''    # a string that represents the current operating system.
        self.platform       = ''    # a string representing the platform of the browser.
        self.plugins        = []    # an array of the plugins installed in the browser.
        self.product        = ''    # the product name of the current browser. (e.g. "Gecko")
        self.productSub     = ''    # the build number of the current browser (e.g. "20060909")
        self.securityPolicy = ''    # an empty string. In Netscape 4.7x, "US & CA domestic policy" or "Export policy".
        self.userAgent      = ''    # the user agent string for the current browser.
        self.vendor         = ''    # the vendor name of the current browser (e.g. "Netscape6")
        self.vendorSub      = ''    # the vendor version number (e.g. "6.1")
        self.javaEnabled    = true  # Indicates whether the host browser is Java-enabled or not.
        self.taintEnabled   = false # JavaScript taint/untaint functions removed in JavaScript 1.2
        self.mozIsLocallyAvailable = true # Lets code check to see if the document at a given URI is available without using the network.
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