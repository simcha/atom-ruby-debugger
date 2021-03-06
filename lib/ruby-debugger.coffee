View = require './view'
Client = require './client'
{CompositeDisposable} = require 'atom'

module.exports =
class RubyDebugger
  constructor: (state) ->
    @client = new Client()
    @view = new View(state.viewState, @client)
    @panel = atom.workspace.addBottomPanel(item: @view.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ruby-debugger:toggle': => @toggle()
    @subscriptions.add atom.commands.add '.editor', 'ruby-debugger:breakpoint-toggle': @breakpointToggleAtCurrentLine
    # @panel.destroy()
    # @subscriptions.dispose()
    # @view.destroy()
    # @client.destroy()

  serialize: ->
    viewState: @view.serialize()

  toggle: ->
    if @panel.isVisible()
      @panel.hide()
    else
      @panel.show()
  #thanks to https://github.com/anandthakker/atom-node-debug
  breakpointToggleAtCurrentLine: (event)=>
    model = event.currentTarget.getModel()
    scriptUrl = model.getURI()
    lineNumber = 1 + model.getCursorScreenPosition().row
    @client.addBrakepoint({scriptUrl, lineNumber})
    #   .done =>
    #     debug('toggled breakpoint')
    #     @updateMarkers()
    #   , (error) -> debug(error)
