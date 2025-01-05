type t = {
  src: string,
  title: string,
}

module Decode = {
  open Json.Decode

  let decodeThumbnailData = object(field => {
    src: field.required("src", string),
    title: field.required("title", string),
  })

  let decoder = v => {
    Console.log(("decoder got", v))
    v->Json.decode(decodeThumbnailData)
  }
}
