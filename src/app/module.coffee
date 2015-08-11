hide = (query) -> () -> document.querySelector(query).className = "hidden"

show = (query) -> () -> document.querySelector(query).className = ""

debug = (msg) -> console.log "QRDisplayModule - DEBUG: #{msg}"

class QRDisplayModule

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
    showErrorMessage "An error occourred while trying to load data for resource: #{resource}. Description: #{error}"
    @hideLoading()
    @showError()

  attrToJson: (attributeName) =>
    try
      return JSON.parse supersonic.module.attributes.get(attributeName)
    catch error
      @showErrorMessage "Could not parse the attribute: #{attributeName}! Error: #{error}"

  getFieldLabels: => @attrToJson "field-labels"

  getResourceInfo: => @attrToJson "resource-info"

  loadRecordData: (recordId, resourceInfo, fieldLabels) =>
    model = supersonic.data.model resourceInfo.resource

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
    #fieldLabels = @getFieldLabels()
    debug "start() recordId: #{recordId} resourceInfo: #{JSON.stringify(resourceInfo)}"

    @loadRecordData recordId, resourceInfo unless @invalidParameters recordId, resourceInfo

document.addEventListener "DOMContentLoaded", new QRDisplayModule().start
