hide = (query) -> () -> document.querySelector(query).className = "hidden"

show = (query) -> () -> document.querySelector(query).className = ""

debug = (msg) -> supersonic.logger.debug "QRDisplayModule: #{msg}"

class QRDisplayModule

  @constructor: ->
    supersonic.data.channel('QRDisplay-show').subscribe (recordId) ->
      resourceInfo = @getResourceInfo()
      debug "channel handler() recordId: #{recordId} resourceInfo: #{JSON.stringify(resourceInfo)}"
      @loadRecordData recordId, resourceInfo unless @invalidParameters recordId, resourceInfo

  hideLoading: hide("#loading")
  showLoading: show("#loading")

  showError: show("#errorMessage")

  showContent: show("#content")

  detailRecord: (fields) -> (record) ->
    template = Handlebars.compile(document.querySelector("#detail-record-template").innerHTML)
    context =
      list: fields.map (field, index) -> {title:field, value:record[field]}
    document.querySelector("#content").innerHTML = template context

  showErrorMessage: (msg) =>
    document.querySelector("#errorMessage").innerText = msg
    @hideLoading()
    @showError()

  handleLoadError: (resource) -> (error) =>
    @showErrorMessage "An error occourred while trying to load data for resource: #{resource}.\n Description: #{error}"
    @hideLoading()
    @showError()

  attrToJson: (attributeName) =>
    try
      return JSON.parse supersonic.module.attributes.get(attributeName)
    catch error
      @showErrorMessage "Could not parse the attribute: #{attributeName}! Error: #{error}"

  getFieldLabels: => @attrToJson "field-labels"

  getResourceInfo: => @attrToJson "resource-info"

  showLoadingMessage: (msg) => document.querySelector("#loadingMessage").innerText = msg

  #TODO: handle invalid id and record not found
  loadRecordData: (recordId, resourceInfo, fieldLabels) =>
    model = supersonic.data.model resourceInfo.resource

    @showLoadingMessage "Loading record details..."

    model.find(recordId)
      .then @detailRecord(resourceInfo.fields, fieldLabels)
      .then @hideLoading
      .then @showContent
      .catch(@handleLoadError(resourceInfo.resource))

  invalidParameters: (recordId, resourceInfo) ->
    if recordId? && resourceInfo?
      false
    else
      @showErrorMessage "Required parameters not provided!"
      true

  start: =>
    recordId = supersonic.module.attributes.get "id"
    resourceInfo = @getResourceInfo()

    debug "start() recordId: #{recordId} resourceInfo: #{JSON.stringify(resourceInfo)}"

    @loadRecordData recordId, resourceInfo unless @invalidParameters recordId, resourceInfo

    #TODO: remove this test below
    someTest = supersonic.module.attributes.get "someTest"
    alert "This attribute should come as a parameter: #{someTest}"

document.addEventListener "DOMContentLoaded", new QRDisplayModule().start
