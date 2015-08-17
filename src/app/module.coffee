hide = (query) -> () -> document.querySelector(query).className = "hidden"

show = (query) -> () -> document.querySelector(query).className = ""

debug = (msg) ->
  console.log "QRDisplayModule: #{msg}"
  supersonic.logger.debug "QRDisplayModule: #{msg}"

class QRDisplayModule

  showError: show("#errorMessage")

  showErrorMessage: (msg) =>
    document.querySelector("#errorMessage").innerText = msg
    @showError()

  invalidParameters: (recordId, resourceName) ->
    if recordId? && recordId != "" && resourceName? && resourceName != ""
      false
    else
      @showErrorMessage "Required parameters not provided! recordId: #{recordId} resourceName: #{resourceName}"
      true

  generateQRCode: (recordId, resourceName) =>
    qrCodeElement = document.querySelector "#qrcode"
    qrCodeOptions =
      text: "#{resourceName}:#{recordId}"
      width: 290
      height: 290
      colorDark : "#000000"
      colorLight : "#ffffff"
      correctLevel : QRCode.CorrectLevel.H

    qrCode = new QRCode qrCodeElement, qrCodeOptions

  getParam:(name)=>
    supersonic.module.attributes.get name

  start: =>
    recordId = @getParam "id" || @getParam "record-id"
    resourceName = supersonic.module.attributes.get "resource-name"
    debug "start() recordId: #{recordId} resourceName: #{resourceName}"

    @generateQRCode recordId, resourceName unless @invalidParameters recordId, resourceName

document.addEventListener "DOMContentLoaded", new QRDisplayModule().start
