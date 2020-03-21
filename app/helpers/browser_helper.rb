module BrowserHelper
  def browser_styles(classes = [])
    browser = Browser.new(request.user_agent)
    classes.push(browser.name.try(:downcase))
    classes.push("edge#{browser.version}") if browser.edge?
    classes.push("ie#{browser.version}") if browser.ie?
    classes.push(detect_device(browser))
    classes
  end

  def detect_device(browser)
    :'mobile-device' if browser.device.mobile?
    :'tablet-device' if browser.device.tablet?
    :'tv-device' if browser.device.tv?
    :'desktop-device' if desktop_device?(browser)
  end

  def desktop_device?(browser)
    return false if browser.device.mobile? || browser.device.tablet? || browser.device.tv?

    p = browser.platform
    p.mac? || p.linux? || p.windows? || p.other?
  end
end
