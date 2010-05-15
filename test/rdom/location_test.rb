require File.expand_path('../../test_helper', __FILE__)

class LocationTest < Test::Unit::TestCase
  attr_reader :google, :github, :location

  def setup
    stub_request(:any, /./).to_return { |request| { :body => request.uri.to_s } }
    @google = 'http://www.google.com:80/search?q=foo#test'
    @github = 'http://github.com:80'

    @location = RDom::Location.new(RDom::Window.new)
    location.href = google
  end

  # If the absolute URI reference for the Location's current location has a
  # fragment identifier, then the value of the hash attribute the value of this
  # attribute MUST be the string concatenation of the hash mark(#) and the
  # fragment identifier. Otherwise, the value of the hash attribute MUST be the
  # empty string. When this atribute is set to a new value new-hash, user agents
  # MUST perform the following steps: Give the hash attribute the value
  # new-hash. Reconstruct the location URI Navigate to the result of step 2.
  test "Location#hash: returns the the part of the URL that follows the # symbol, including the # symbol", :dom_0 do
    assert_equal '#test', location.hash
  end

  # This attribute represents the network host of the Location's URI. If the
  # port attribute is not null then the host attribute's value is the
  # concatenation of the hostname attribute, a colon (:) and the port attribute.
  # If the port attribute is null then the host attribute's value is identical
  # to the hostname attribute.
  test "Location#host: returns the host name and port number", :dom_0 do
    assert_equal 'www.google.com:80', location.host
  end

  # This attribute represents the name or IP address of the network location
  # without any port number
  test "Location#hostname: returns the host name (without the port number or square brackets)", :dom_0 do
    assert_equal 'www.google.com', location.hostname
  end

  # The value of the href attribute MUST be the absolute URI reference that is
  # the Location's current location When the href attribute is set, the
  # Location's window MUST navigate to the newly set value.
  test "Location#href: returns the entire URL", :dom_0 do
    assert_equal google, location.href
  end

  # This attribute represents the path component of the Location's URI which
  # consists of everything after the host and port up to and excluding the first
  # question mark (?) or hash mark (#).
  test "Location#pathname: returns the path (relative to the host)", :dom_0 do
    assert_equal '/search', location.pathname
  end

  # This attribute represents the port number of the network location.
  test "Location#port: returns the port number of the URL", :dom_0 do
    assert_equal '80', location.port
  end

  # This attribute represents the scheme of the URI including the trailing
  # colon (:)
  test "Location#protocol: returns the protocol of the URL", :dom_0 do
    assert_equal 'http:', location.protocol
  end

  # This attribute represents the query portion of a URI. It consists of
  # everything after the pathname up to and excluding the first hash mark (#).
  test "Location#search: returns the part of the URL that follows the ? symbol, including the ? symbol", :dom_0 do
    assert_equal '?q=foo', location.search
  end

  test "Location#assign(url): Load the document at the provided URL", :dom_0 do
    location.assign(github)

    assert_equal github, location.href
    assert_equal google, location.history.first
    assert_equal github, location.history.last
  end
  
  # This function forces the host application to reload the resource
  # identified by the Location.
  test "Location#reload(forceget): Reload the document from the current URL.", :dom_0 do
    # forceget is a boolean, which, when it is true, causes the page to always be reloaded from the server.
    # If it is false or not specified, the browser may reload the page from its cache
  end

  # This function replaces the current history entry with the url specified.
  test "Location#replace(url): Replace the current document with the one at the provided URL", :dom_0 do
    location.replace(github)

    assert_equal github, location.href
    assert_equal google, location.history.first
    assert_equal google, location.history.last
  end

  test "Location#toString: Returns the string representation of the Location object's URL", :dom_0 do
    assert_equal google, location.toString
  end

  test "modifying the url's hash (fragment) loads the resulting url to the window", :dom_0 do
    # TODO these do not actually test what the test describes
    location.hash = '#foo'
    assert_equal 'foo', URI.parse(location.href).fragment
  end

  test "modifying the url's host loads the resulting url to the window", :dom_0 do
    location.host = 'github.com:3030'
    assert_equal 'github.com', URI.parse(location.href).host
    assert_equal 3030, URI.parse(location.href).port
  end

  test "modifying the url's hostname loads the resulting url to the window", :dom_0 do
    location.hostname = 'github.com'
    assert_equal 'github.com', URI.parse(location.href).host
  end

  test "modifying the url's href loads the resulting url to the window", :dom_0 do
    url = 'http://github.com:8080/home?foo=bar#baz'
    location.href = url
    assert_equal url, location.href
  end

  test "modifying the url's pathname loads the resulting url to the window", :dom_0 do
    location.pathname = 'home'
    assert_equal '/home', URI.parse(location.href).path
  end

  test "modifying the url's port loads the resulting url to the window", :dom_0 do
    location.port = '8080'
    assert_equal 8080, URI.parse(location.href).port
  end

  test "modifying the url's protocol loads the resulting url to the window", :dom_0 do
    location.protocol = 'https'
    assert_equal 'https', URI.parse(location.href).scheme
  end
end

