import gleam/bytes_builder.{type BytesBuilder}
import gleam/erlang/process
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io
import mist

pub fn main() {
  io.println("Starting server")
  let assert Ok(_) =
    router
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(8080)
    |> mist.start_http
  io.println("Server started on port 8080")
  process.sleep_forever()
}

fn router(req: Request(a)) -> Response(mist.ResponseData) {
  case request.path_segments(req), req.method {
    ["hello_world"], http.Get -> hello_world()
    _, _ -> not_found()
  }
}

fn hello_world() {
  let body =
    bytes_builder.from_string("Hello, world!")
    |> mist.Bytes
  response.new(200)
  |> response.set_header("Content-Type", "text/plain")
  |> response.set_body(body)
}

fn method_not_allowed() {
  response.new(405)
  |> response.set_body(bytes_builder.from_string("Method not allowed"))
}

fn not_found() {
  let body =
    bytes_builder.from_string("Not found")
    |> mist.Bytes
  response.new(404)
  |> response.set_body(body)
}
