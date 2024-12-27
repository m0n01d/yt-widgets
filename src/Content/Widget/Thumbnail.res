@new external makeFileReader: unit => 'a = "FileReader"
@send external readAsDataURL: ('reader, Webapi.File.t) => 'a = "readAsDataURL"

open Webapi.Dom
open Belt
open File

let dummyData = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII"

let targetElSelector = "ytcp-video-thumbnail-editor"
let stillPickerSelector = "ytcp-video-custom-still-editor"
let thumbnailImgSelector = "ytcp-thumbnail-uploader img#img-with-fallback"
let fileLoader = "ytcp-thumbnail-uploader input#file-loader"
let titleElSelector = "ytcp-video-title #textbox"

// @TODO
// get mimetype to save for future use when reuploading an edited photo
// get title to use in preview, for now use Lorem Ipsum

let query = _ => {
  [targetElSelector, stillPickerSelector, thumbnailImgSelector, fileLoader]
  ->Js.Array2.map(selector => Ui.queryDom(None, selector, 3)->Js.Promise2.then(el => el))
  ->Js.Promise2.all
}

type colorPalette = array<array<int>>
module Palette = {
  @module("color.js") external prominent: string => promise<colorPalette> = "prominent"

  @react.component
  let make = (~src) => {
    let (maybeColors: colorPalette, setColors) = React.useState(_ => [])

    React.useEffect1(() => {
      prominent(src)
      ->Js.Promise2.then(theColorPalette => {
        setColors(_ => theColorPalette)

        Js.Promise2.resolve() // have to resolve
      })
      ->ignore // have to ignore

      None
    }, [src])

    <div style={ReactDOM.Style.make(~display="flex", ~margin="1em 0", ())}>
      {maybeColors
      ->Js.Array2.map(color => {
        let bgColor = `rgb(${Js.Array.joinWith(",", color)})`

        <span style={ReactDOM.Style.make(~background=bgColor, ~flex="1 0 0", ~height="52px", ())} />
      })
      ->React.array}
    </div>
  }
}

module Preview = {
  type userImg = FromUser(string) | FromYoutube(string)
  type model = {
    maybeThumbnailEl: option<Dom.element>,
    maybeImgSrc: option<userImg>,
    maybeDialog: option<unit>,
  }

  type msg =
    ClosedDialog | ClickedEditThumb(string) | SetImgSrc(userImg) | SetThumbnailEl(Dom.element)
  let update = (state: model, action: msg) => {
    switch action {
    | ClosedDialog => {...state, maybeDialog: None}

    | ClickedEditThumb(src) => {...state, maybeDialog: Some()}
    | SetImgSrc(src) => {...state, maybeImgSrc: Some(src)}
    | SetThumbnailEl(el) => {
        let maybeImgSrc = el->Element.getAttribute("src")->Option.map(s => FromYoutube(s))
        {...state, maybeImgSrc, maybeThumbnailEl: Some(el)}
      }
    }
  }

  let viewThumbnail = src => {
    <Mui.Box>
      <div
        style={ReactDOM.Style.make(
          ~position="relative",
          ~display="block",
          ~margin="0.2rem 0.25rem",
          (),
        )}>
        <img style={ReactDOM.Style.make(~width="100%", ())} src />
        <span
          style={ReactDOM.Style.make(
            ~background="white",
            ~border="1px solid black",
            ~bottom="0",
            ~left="33%",
            ~position="absolute",
            ~top="0",
            ~width="2px",
            ~zIndex="1",
            (),
          )}
        />
        <span
          style={ReactDOM.Style.make(
            ~background="white",
            ~border="1px solid black",
            ~bottom="0",
            ~left="66%",
            ~position="absolute",
            ~top="0",
            ~width="2px",
            ~zIndex="1",
            (),
          )}
        />
        <span
          style={ReactDOM.Style.make(
            ~background="white",
            ~border="1px solid black",
            ~height="2px",
            ~left="0",
            ~position="absolute",
            ~right="0",
            ~top="33%",
            ~zIndex="1",
            (),
          )}
        />
        <span
          style={ReactDOM.Style.make(
            ~background="white",
            ~border="1px solid black",
            ~height="2px",
            ~left="0",
            ~position="absolute",
            ~right="0",
            ~top="66%",
            ~zIndex="1",
            (),
          )}
        />
      </div>
      <div>
        <Palette src />
      </div>
    </Mui.Box>
  }

  let view = (state, dispatch) => {
    let viewDialog = () => {
      <Mui.Dialog
        fullWidth={true}
        onClose={(_, _) => dispatch(ClosedDialog)}
        maxWidth={Xs}
        open_={true}
        sx={Mui.Sx.obj({zIndex: {Mui.System.Value.Number(2206.0)}})}>
        {"dialog"->React.string}
      </Mui.Dialog>
    }
    let maybeDialog = switch state.maybeDialog {
    | None => React.null
    | Some(_) => viewDialog()
    }

    switch state.maybeImgSrc {
    | Some(FromYoutube(src)) => <Mui.Box> {viewThumbnail(src)} </Mui.Box>
    | Some(FromUser(src)) =>
      <Mui.Box style={ReactDOM.Style.make(~position="relative", ())}>
        {viewThumbnail(src)}
        <div>
          <Mui.Button
            endIcon={<Ui.Icon.NoteAdd />}
            onClick={_ => dispatch(ClickedEditThumb(src))}
            sx={Mui.Sx.obj({
              margin: Mui.System.Value.String("1rem 0"),
              width: Mui.System.Value.String("142px"),
              position: Mui.System.Value.String("absolute"),
              top: Mui.System.Value.String("1rem"),
              left: Mui.System.Value.String("1rem"),
            })}
            variant={Contained}>
            {"Preview Thumbnail"->React.string}
          </Mui.Button>
        </div>
      </Mui.Box>
    | None => React.null
    }
  }
  @react.component
  let make = () => {
    let initialImgSrc =
      document
      ->Document.querySelector(thumbnailImgSelector)
      ->Option.flatMap(img => img->Element.getAttribute("src"))
      ->Option.map(s => FromYoutube(s))

    let initialState = {maybeImgSrc: initialImgSrc, maybeThumbnailEl: None, maybeDialog: None}
    let (state, dispatch) = React.useReducer(update, initialState)
    let queryResult = ReactQuery.useQuery({
      queryFn: query,
      queryKey: ["Thumbnail.Preview"],
      refetchOnMount: ReactQuery.refetchOnMount(#bool(true)),
      refetchOnWindowFocus: ReactQuery.refetchOnWindowFocus(#bool(false)),
      staleTime: ReactQuery.time(#number(1)),
    })

    switch queryResult {
    | {isError: true, error, _} => {
        Console.log(error)
        React.null
      }
    | {data: Some([targetEl, stillPickerEl, thumbnailImgEl, fileLoaderEl]), _} => {
        switch fileLoaderEl->HtmlInputElement.ofElement {
        | Some(fileInput) => {
            let rec fn = ev => {
              let target = ev->InputElement.Event.target
              let files = target->InputElement.files

              files->Array.forEach(f => {
                let reader = File.Reader.make()
                reader->File.Reader.addEventListener(#load, () => {
                  let src = File.Reader.result(reader)
                  dispatch(SetImgSrc(FromUser(src)))
                  Console.log(src)
                })
                reader->File.Reader.readAsDataURL(f)
              })
              fileInput->InputElement.removeEventListener(#change, fn)
            }
            fileInput->InputElement.addEventListener(#change, fn)
          }
        | None => Console.log("what")
        }

        if None == state.maybeThumbnailEl {
          dispatch(SetThumbnailEl(thumbnailImgEl))
        }

        ReactDOM.createPortal(view(state, dispatch), targetEl)
      }
    | _ => React.null
    }
  }
}

let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  <ReactQuery.Provider client>
    <Preview />
  </ReactQuery.Provider>
}

/*


function dispatchChangeEventWithDataUrl(inputElement, dataUrl) {
  // Create a new File object from the data URL
  const file = dataURLtoFile(dataUrl, 'image.png'); // Replace 'image.png' with the appropriate file name and type

  // Create a DataTransfer object and add the file to it
  const dataTransfer = new DataTransfer();
  dataTransfer.items.add(file);

  // Set the files property of the input element to the DataTransfer object
  inputElement.files = dataTransfer.files;

  // Dispatch the change event
  const changeEvent = new Event('change', { bubbles: true });
  inputElement.dispatchEvent(changeEvent);
}

function dataURLtoFile(dataUrl, filename) {
  const arr = dataUrl.split(',');
  const mime = arr[0].match(/:(.*?);/)[1];
  const bstr = atob(arr[1]);
  let n = bstr.length;
  const u8arr = new Uint8Array(n);

  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }

  return new File([u8arr], filename, { type: mime });
}

// Example usage:
const inputElement = document.getElementById('myInput');
const dataUrl = 'data:image/png;base64,...'; // Your data URL here

dispatchChangeEventWithDataUrl(inputElement, dataUrl);

 */
