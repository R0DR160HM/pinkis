import gleam/bytes_builder.{type BytesBuilder}
import gleam/erlang/process
import gleam/http
import gleam/http/elli
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io

pub fn main() {
  io.println("Starting server")
  let assert Ok(_) = elli.start(router, on_port: 3000)
  io.println("Server started on port 3000")
  process.sleep_forever()
}

fn router(req: Request(a)) -> Response(BytesBuilder) {
  case req.path, req.method {
    "/hello_world", http.Get -> hello_world()
    "/hello_world", _ -> method_not_allowed()
    _, _ -> not_found()
  }
}

fn hello_world() {
  let body = bytes_builder.from_string("Hello, world!")
  response.new(200)
  |> response.set_body(body)
}

fn method_not_allowed() {
  response.new(405)
  |> response.set_body(bytes_builder.from_string("Method not allowed"))
}

fn not_found() {
  response.new(404)
  |> response.set_body(bytes_builder.from_string("Not found"))
}
