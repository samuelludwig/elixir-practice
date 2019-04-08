# Chapter 2 Notes

***

## The Lay of the Land

- You can think of any web server as a function.

  - **web server**: computer that hosts a website on the internet at a specific IP address.

- When you search and go to a URL (which is translated to an IP address), think of it as a *function call* to the `webserver` function.

- The function takes input (your request) and generates a response.

  - ```
    > webserver(request)
    webserver_response
    ```

- A web server is a natural problem for a functional language to solve.

### Simple Functions

- Phoenix works similarly to how Elixir works:

  - In Elixir, you chain together functions to transform some input into an output that you want-

    - ```
      > 2 |> inc() |> inc() |> dec()
      3
      ```

    - The **`|>`**, or *pipe operator* takes the value on the left and passes it as the first argument to the function on the right.

    - These compositions are called *pipes* or *pipelines*.

    - Each individual function is called a *segment* or a *pipe segment*.

    - **NOTE**: Since function compositions are functions themselves, this means you can make *pipelines of pipelines*.

  - A Phoenix program isn't special, it's also a pipeline:

    - ```
      > connection |> phoenix
      transformed_connection
      ```

    - The Phoenix program takes the argument `connection` and returns some transformation of that `connection`.

  - What is a 'connection' exactly?

    - We aren't using 'connection' as an abstract term, its a real thing that we interact with in our program.
    - A connection is an Elixir *struct*, a map with a known set of fields.
    - A `connection` is immediately created when we access a webserver (when we go to it's URL).
    - A `connection` has all of the information the phoenix application will ever need, think of it like the form you fill out at a doctors office:
      - What's your name?
      - Where are you coming from?
      - Where are you going?
      - What are you trying to do?
      - What information are you sending/bringing with you, if any?
      - Ect. Thankfully this is all done automatically for us as soon as a user accesses our web server.
      - The `connection` struct itself is rather ugly and complicated, and thankfully we don't need to know about most of its dirty details, we usually only care about certain small sections. If you want to see what a general `connection` struct looks like, [click here](link_to_struct_gist).
    - Each layer of Phoenix makes little changes to our `connection`, slowly honing it down to exactly what we want.
    - By the end of the complete `phoenix` pipeline, our `connection` is transformed to the output we want, and this output is then either rendered to a webpage of our design, or it's used to update a database of ours, or both.

  ### The Layers of Phoenix

  - What are the 'layers' of Phoenix?

    - Our function `phoenix` we mentioned above is really a composition of many functions (A.K.A. pipelines)

    - Zooming in a level into our `phoenix` function, we can see that it is composed of four main pipelines:

      - `endpoint`

      - `router`

      - `pipelines`

      - `controller`

      - To fix any immediate confusion; just think of the `pipelines` er... pipeline as "other miscellaneous functions".

      - ```
        > connection |> phoenix
        ```

        is equivalent to

        ```
        > connection
          |> endpoint()
          |> router()
          |> pipelines()
          |> controller()
        ```

        