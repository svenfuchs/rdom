require File.expand_path('../../test_helper', __FILE__)

class LocationTest < Test::Unit::TestCase
  attr_reader :window, :google, :github, :location

  def setup
    stub_request(:any, /./).to_return { |request| { :body => request.uri.to_s } }

    @google = 'http://www.google.com:80/search?q=foo#test'
    @github = 'http://github.com:80'
    @window = RDom::Window.new(google)
    @location = window.location

    window.evaluate("var location = window.location")
  end

  # If the absolute URI reference for the Location's current location has a
  # fragment identifier, then the value of the hash attribute the value of this
  # attribute MUST be the string concatenation of the hash mark(#) and the
  # fragment identifier. Otherwise, the value of the hash attribute MUST be the
  # empty string. When this atribute is set to a new value new-hash, user agents
  # MUST perform the following steps: Give the hash attribute the value
  # new-hash. Reconstruct the location URI Navigate to the result of step 2.
  test "ruby: Location#hash: returns the the part of the URL that follows the # symbol, including the # symbol", :ruby, :dom_0 do
    assert_equal '#test', location.hash
  end

  test "js: Location#hash: returns the the part of the URL that follows the # symbol, including the # symbol", :js, :dom_0 do
    assert_equal '#test', window.evaluate("location.hash")
  end

  # This attribute represents the network host of the Location's URI. If the
  # port attribute is not null then the host attribute's value is the
  # concatenation of the hostname attribute, a colon (:) and the port attribute.
  # If the port attribute is null then the host attribute's value is identical
  # to the hostname attribute.
  test "ruby: Location#host: returns the host name and port number", :ruby, :dom_0 do
    assert_equal 'www.google.com:80', location.host
  end

  test "js: Location#host: returns the host name and port number", :js, :dom_0 do
    assert_equal 'www.google.com:80', window.evaluate("location.host")
  end

  # This attribute represents the name or IP address of the network location
  # without any port number
  test "ruby: Location#hostname: returns the host name (without the port number or square brackets)", :ruby, :dom_0 do
    assert_equal 'www.google.com', location.hostname
  end

  test "js: Location#hostname: returns the host name (without the port number or square brackets)", :js, :dom_0 do
    assert_equal 'www.google.com', window.evaluate("location.hostname")
  end

  # The value of the href attribute MUST be the absolute URI reference that is
  # the Location's current location When the href attribute is set, the
  # Location's window MUST navigate to the newly set value.
  test "ruby: Location#href: returns the entire URL", :ruby, :dom_0 do
    assert_equal google, location.href
  end

  test "js: Location#href: returns the entire URL", :js, :dom_0 do
    assert_equal google, window.evaluate("location.href")
  end

  # This attribute represents the path component of the Location's URI which
  # consists of everything after the host and port up to and excluding the first
  # question mark (?) or hash mark (#).
  test "ruby: Location#pathname: returns the path (relative to the host)", :ruby, :dom_0 do
    assert_equal '/search', location.pathname
  end

  test "js: Location#pathname: returns the path (relative to the host)", :js, :dom_0 do
    assert_equal '/search', window.evaluate("location.pathname")
  end

  # This attribute represents the port number of the network location.
  test "ruby: Location#port: returns the port number of the URL", :ruby, :dom_0 do
    assert_equal '80', location.port
  end

  test "js: Location#port: returns the port number of the URL", :js, :dom_0 do
    assert_equal '80', window.evaluate("location.port")
  end

  # This attribute represents the scheme of the URI including the trailing
  # colon (:)
  test "ruby: Location#protocol: returns the protocol of the URL", :ruby, :dom_0 do
    assert_equal 'http:', location.protocol
  end

  test "js: Location#protocol: returns the protocol of the URL", :js, :dom_0 do
    assert_equal 'http:', window.evaluate("location.protocol")
  end

  # This attribute represents the query portion of a URI. It consists of
  # everything after the pathname up to and excluding the first hash mark (#).
  test "ruby: Location#search: returns the part of the URL that follows the ? symbol, including the ? symbol", :ruby, :dom_0 do
    assert_equal '?q=foo', location.search
  end

  test "js: Location#search: returns the part of the URL that follows the ? symbol, including the ? symbol", :js, :dom_0 do
    assert_equal '?q=foo', window.evaluate("location.search")
  end

  test "ruby: Location#assign(url): Load the document at the provided URL", :ruby, :dom_0 do
    location.assign(github)

    assert_equal github, location.href
    assert_equal 2, window.history.size
    assert_equal google, window.history.first
    assert_equal github, window.history.last
  end

  test "js: Location#assign(url): Load the document at the provided URL", :js, :dom_0 do
    window.evaluate("location.assign('#{github}')")

    assert_equal github, location.href
    assert_equal 2, window.history.size
    assert_equal google, window.history.first
    assert_equal github, window.history.last
  end

  # This function forces the host application to reload the resource
  # identified by the Location.
  test "ruby: Location#reload(forceget): Reload the document from the current URL.", :ruby, :dom_0 do
    # forceget is a boolean, which, when it is true, causes the page to always be reloaded from the server.
    # If it is false or not specified, the browser may reload the page from its cache
    # TODO
  end

  # This function replaces the current history entry with the url specified.
  test "ruby: Location#replace(url): Replace the current document with the one at the provided URL", :ruby, :dom_0 do
    location.replace(github)

    assert_equal github, location.href
    assert_equal 1, window.history.size
    assert_equal github, window.history.first
  end

  test "js: Location#replace(url): Replace the current document with the one at the provided URL", :js, :dom_0 do
    window.evaluate("location.replace('#{github}')")

    assert_equal github, location.href
    assert_equal 1, window.history.size
    assert_equal github, window.history.first
  end

  test "ruby: Location#toString: Returns the string representation of the Location object's URL", :ruby, :dom_0 do
    assert_equal google, location.toString
  end

  test "js: Location#toString: Returns the string representation of the Location object's URL", :js, :dom_0 do
    assert_equal google, window.evaluate("location.toString()")
  end

  test "ruby: modifying the url's hash (fragment)", :ruby, :dom_0 do
    location.hash = '#foo'
    assert_equal 'foo', URI.parse(location.href).fragment
    # assert_equal 'foo', URI.parse(window.document.body.textContent).fragment # won't be passed through webmock
  end
  
  test "js: modifying the url's hash (fragment) loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.hash = '#foo'")
    assert_equal 'foo', URI.parse(location.href).fragment
    # assert_equal 'foo', URI.parse(window.document.body.textContent).fragment # won't be passed through webmock
  end
  
  test "ruby: modifying the url's host loads the resulting url to the window", :ruby, :dom_0 do
    location.host = 'github.com:8080'
    assert_equal 'github.com', URI.parse(location.href).host
    assert_equal 'github.com', URI.parse(window.document.body.textContent).host
    assert_equal 8080, URI.parse(location.href).port
    assert_equal 8080, URI.parse(window.document.body.textContent).port
  end
  
  test "js: modifying the url's host loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.host = 'github.com:8080'")
    assert_equal 'github.com', URI.parse(location.href).host
    assert_equal 'github.com', URI.parse(window.document.body.textContent).host
    assert_equal 8080, URI.parse(location.href).port
    assert_equal 8080, URI.parse(window.document.body.textContent).port
  end
  
  test "ruby: modifying the url's hostname loads the resulting url to the window", :ruby, :dom_0 do
    location.hostname = 'github.com'
    assert_equal 'github.com', URI.parse(location.href).host
    assert_equal 'github.com', URI.parse(window.document.body.textContent).host
  end
  
  test "js: modifying the url's hostname loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.hostname = 'github.com'")
    assert_equal 'github.com', URI.parse(location.href).host
    assert_equal 'github.com', URI.parse(window.document.body.textContent).host
  end
  
  test "ruby: modifying the url's href loads the resulting url to the window", :ruby, :dom_0 do
    url = 'http://github.com:8080/home?foo=bar'
    location.href = url
    assert_equal url, location.href
    assert_equal url, window.document.body.textContent
  end
  
  test "js: modifying the url's href loads the resulting url to the window", :js, :dom_0 do
    url = 'http://github.com:8080/home?foo=bar'
    window.evaluate("location.href = '#{url}'")
    assert_equal url, location.href
    assert_equal url, window.document.body.textContent
  end
  
  test "ruby: modifying the url's pathname loads the resulting url to the window", :ruby, :dom_0 do
    location.pathname = 'home'
    assert_equal '/home', URI.parse(location.href).path
    assert_equal '/home', URI.parse(window.document.body.textContent).path
  end
  
  test "js: modifying the url's pathname loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.pathname = 'home'")
    assert_equal '/home', URI.parse(location.href).path
    assert_equal '/home', URI.parse(window.document.body.textContent).path
  end
  
  test "ruby: modifying the url's port loads the resulting url to the window", :ruby, :dom_0 do
    location.port = '8080'
    assert_equal 8080, URI.parse(location.href).port
    assert_equal 8080, URI.parse(window.document.body.textContent).port
  end
  
  test "js: modifying the url's port loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.port = '8080'")
    assert_equal 8080, URI.parse(location.href).port
    assert_equal 8080, URI.parse(window.document.body.textContent).port
  end
  
  test "ruby: modifying the url's protocol loads the resulting url to the window", :ruby, :dom_0 do
    location.protocol = 'https'
    assert_equal 'https', URI.parse(location.href).scheme
    assert_equal 'https', URI.parse(window.document.body.textContent).scheme
  end
  
  test "js: modifying the url's protocol loads the resulting url to the window", :js, :dom_0 do
    window.evaluate("location.protocol = 'https'")
    assert_equal 'https', URI.parse(location.href).scheme
    assert_equal 'https', URI.parse(window.document.body.textContent).scheme
  end
end

