module Inject = {
  type document
  type element
  type child
  @send external getElementById: (document, string) => Dom.element = "getElementById"
  @val external doc: document = "document"

  @send external createElement: (document, string) => Dom.element = "createElement"
  @send external appendChild: (Dom.element, Dom.element) => Dom.element = "appendChild"

  let createInjectElement = () => {
    createElement(doc, "div")
  }

  let mount = (target, widget) => {
    let wrapper = createInjectElement()
    let root = ReactDOM.Client.createRoot(wrapper)
    ReactDOM.Client.Root.render(root, widget)
    target->appendChild(wrapper)
  }
}
