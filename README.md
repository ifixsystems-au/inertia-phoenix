# Inertia - Phoenix

A proof of concept hooking up [Phoenix Framework](https://www.phoenixframework.org/) and [InertiaJS](https://inertiajs.com/).

## Installation

Install from the Github repo:

    defp deps do
      [
        {:inertia, git: "https://github.com/ifixsystems-au/inertia-phoenix.git"}
      ]
    end

## Configuration

Add the Inertia renderer to your controllers (or web entrypoint):

    def controller do
      quote do
        ...
        import Inertia.Renderer
        ...
      end
    end

Add the Inertia view helper to your views (or web entrypoint):

    def view do
      quote do
        ...
        import Inertia.ViewHelpers
        ...
      end
    end

Modify the pipeline to check the [assets version](https://inertiajs.com/the-protocol#asset-versioning), which will respond with a 409 if the assets are stale, and to set a default view to use in the pipeline:

    pipeline :inertia do
      ...
      plug Inertia.Plugs.AssetsCheck
      plug :put_view, MyAppWeb.InertiaView
      ...
    end

Create the root template named `app.html.eex` in the appropriate template directory, which uses the view helper to generate the root `div` mounting point (https://inertiajs.com/the-protocol#html-responses). `templates/inertia/app.html.eex`:

    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><%= assigns[:page_title] || "InertiaJS + Phoenix Framework" %></title>
        <link rel="stylesheet" href="<%= Routes.static_path(@conn, "/css/app.css") %>"/>
        <%= csrf_meta_tag() %>
      </head>
      <body>
        <%= inertia(@page) %>
        <script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/app.js") %>"></script>
      </body>
    </html>

Now, set up [Inertia](https://inertiajs.com/installation), your [client-side framework of choice](https://inertiajs.com/client-side-setup), and the appropriate Inertia client-side adapter. You can check out my [test application](https://github.com/totaltrash/test_phoenix_inertia) which uses Vue.

## Usage

### Controllers

`inertia/3` will build either the full HTML response or JSON response, depending on whether the `X-Inertia` request header is set. Pass the `conn`, the component name, and optional props to be passed to the component (as per the [Laravel and Rails examples](https://inertiajs.com/server-side-setup#creating-responses)).

    defmodule MyAppWeb.PageController do
      use MyAppWeb, :controller

      def home(conn, _params) do
        inertia(conn, "Home")
      end

      def items(conn, _params) do
        inertia(conn, "Item/List", %{ "items" => ["Test 1", "Test 2"] })
      end
    end
