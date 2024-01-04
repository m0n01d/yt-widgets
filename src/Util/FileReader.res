type fileReader
type file = {"name": string, "size": int}

@new external make: unit => fileReader = "FileReader"

@send external readAsDataURL: (fileReader, file) => unit = "readAsDataURL"
let prepare: unit => unit = () =>
  %raw(`
  (function() {
    const el = document.querySelector("ytcp-thumbnail-uploader")
    setTimeout(() => {
        el.onFileDrop
    console.log('prep me', el, Object.keys(el))

    }, 3000)


  })()
`)

let onload: (fileReader, string => unit) => unit = %raw(`

    function (reader, cb) {
        setTimeout(() => {
            const el = document.querySelector("ytcp-thumbnail-uploader")
            console.log({el, x: Function.prototype.toString.call(el.startTransfer)})


            const transfer = el["transfer"]
            const file = transfer["blob_"];
            reader.onload = function (e) {
                cb(e.target.result);
            }
            if (file) {
                reader.readAsDataURL(file)
            }
        }, 1000)
    }
        `)

let fileToDataUrl: (string => unit) => unit = continue => {
  let reader = make()
  onload(reader, continue)
  //   readAsDataURL(reader, file)
}
