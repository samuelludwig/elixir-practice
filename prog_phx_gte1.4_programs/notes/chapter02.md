# Chapter 2 Notes

***

## The Lay of the Land

- Important term - **web server**: Computer that hosts a website on the internet at a specific IP address. It holds a collection of files much like a folder on your OS, the files usually contain data and information on how and when to display that data.

- You can think of any web server as a function.

- When you search and go to a URL (which is translated to a web server's IP address), think of it as a *function call* to the `webserver` function.

- The function takes input (your request) and generates a response; the response usually comes in the form of a webpage.

  - ```
    > webserver(request)
    result: webserver_response
    ```

- A web server is a natural problem for a functional language to solve.

### Simple Functions

- Phoenix works similarly to how Elixir works:

  - In Elixir, you chain together functions to transform some input into an output that you want-

    - ```
      > 2 |> inc() |> inc() |> dec()
      result: 3
      ```

    - The **`|>`**, or *pipe operator* takes the value on the left and passes it as the first argument to the function on the right.

    - These compositions are called *pipes* or *pipelines*.

    - Each individual function is called a *segment* or a *pipe segment*.

    - **NOTE**: Since function compositions are functions themselves, this means you can make *pipelines of pipelines*.

  - A Phoenix program isn't special, it's also a pipeline:

    - ```
      > connection |> phoenix
      result: transformed_connection
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
    - The `connection` struct itself is rather ugly and complicated, and thankfully we don't need to know about most of its dirty details, we usually only care about certain small sections. If you want to see what a general `connection` struct looks like, [click here](https://gist.github.com/jamonholmgren/fc3b995d2704b1780b55).
    - Each layer of Phoenix makes little changes to our `connection`, slowly honing it down to exactly what we want.
    - By the end of the complete `phoenix` pipeline, our `connection` is transformed and used to create the output we want, and this output is then either rendered to a webpage of our design, or it's used to update a database of ours, or both.

  ### The Layers of Phoenix

  - What are the 'layers' of Phoenix?

    - Our function: `phoenix` that we mentioned above is really a composition of many functions (A.K.A. pipelines)

    - Zooming in a level into our `phoenix` function, we can see that it is composed of four main parts/pipelines:

      1. `endpoint`

      2. `router`

      3. `pipelines`

      4. `controller`

      - To fix any immediate confusion; just think of the `pipelines` er... pipeline, as "other miscellaneous functions" for now.

        

        **So**

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

  - Lets break these layers down:

    - What is an 'Endpoint'?

      - If we think of a `connection` as the form you fill out at the doctors office, the `endpoint` is the desk clerk you hand it to when you're done.
      - The `endpoint` is the beginning of your applications world, the hole that incoming connections are tossed into.
      - Phoenix kindly creates the endpoint automatically for us, and while you can do some nifty things by playing with it yourself, you can largely get away with not touching/worrying about it at all. Understanding how things work beneath the surface is always useful though. 

    - What is a 'Router'?

      - Sticking with our doctors office analogy, after the desk clerk (`endpoint`) receives your form (`connection`), they will hand it to a nurse. The nurse looks at the "Where are you going?" and "What are you doing?" fields, and points you in the right direction as to where to go. The nurse in this analogy is playing the part of the `router`.
      - The `router` is essentially a giant table/tree of all possible parts of a website you might go to, and when a request comes through an `endpoint`, the `router` will look up where it wants to go in the table, and send it there if the location exists.
      - A `router` might have a few sub-tables depending on who is accessing the site/server, one my be for an API, or a normal user on a web browser. A possible table could also be for admin accounts on the site, that would have access to unique pages normal users wouldn't be able to get to. 
      - The `router` is something that you will interface/work with any time you want to add a new page to your site, and is thankfully not too complicated.
      - A `router` will usually have it's own pipeline that it puts a connection through depending on where it came from, usually something that makes sure that the user is allowed access to wherever it's going, and that everything is 'squared away', i.e. it sets up the browser session so it can keep tabs on everything correctly.

    - What are the 'Pipelines'?

      - `pipelines` is sort of arbitrarily placed in this list; as mentioned before, the `pipelines` layer is not as concrete as the others, where the `endpoint`, `controller`, and `router` are all in separate and distinct files, the `pipelines` are usually spread out and found in different files- as we just said, one or two may be found in the `router` file, for authenticating the user.
      - As for our doctors office, the `pipelines` layer can be considered all the steps taken in-between where staff make sure you're actually a patient of theirs, that you have your appointment scheduled properly, your billing information is correct, that you're seeing the right doctor, that your insurance info is all correct, are you up-to-date on your immunizations, etc.
      - The `pipelines` generally handle common tasks, like making sure a user is authorized to access a certain part of the site, or that a password is a proper length/format, or that user credentials get encrypted/stored properly.
      - You could get away with considering `pipelines` the 'data processing' step in your application, as a loose definition.
      - To emphasize: `pipelines` are still just normal functions and collections of functions like everything else, they aren't special in any way.

    - What is a 'Controller'?

      - In our doctor's office analogy, after the nurse (`router`) brings you to your room, the good doctor themselves will finally pay you a visit and conduct your examination/check-up. The main event here -the doctor- is our `controller`.

      - As is conveniently evident in our analogy,  once you get to where you need to be, the `controller` is where everything you care about as a user happens; it's a big section.

      - The `controller` is so significant that it warrants a zoom-in of its own:

        ```
        > connection |> controller
        ```

        is equivalent to

        ```
        > connection
          |> controller()
          |> common_services()
          |> action()
        ```

      - Let's brake these down as simply as possible:

        - `controller`: the beginning of our user experience, the doctor looks over your paperwork and takes note of the "why are you here?" field.
        - `common_services`: appropriately named- very similar to the `pipelines` layer mentioned above, here the doctor performs the routine check-up steps, say 'ahhh...'.
        - `action`: finally, the thing the user is actually trying to do- make an account, view some data, make a comment, etc, the actual *act* itself happens at this step. To complete our doctors office analogy: perhaps you went to the doctors to get a prescription renewed, at this step, the doctor would confirm that you do indeed still need it, write you the prescription, and send it over to your pharmacy.

      - There is usually a controller for each 'thing' in our program, they could be:

        - a controller for user-focused tasks, which we'd call `UserController`, and it would handle things surrounding account management.
        - a controller for tasks related to blog posts, which we could call `PostController`, and it would handle tasks such as updating/editing a post, deleting a post, creating a new post, etc.

      - There will usually be more than one `action` per `controller`, specifically, each task we want to complete will have an individual action associated with it; if we are looking at our `UserController`, it would likely have:

        - a `get` action, to get the information of a user.
        - a `create` action, to create a new user account.
        - an `update` action, to update a user's information.
        - a `delete` action, to delete a user's account.

      - The `action` is important, and it would be worthwhile to give it a closer look. If you are used to the MVC development pattern, you will start to see parts of it here. Let's crack open our `get` action -the action we would use to show a user-, it might look like:

        ``` 
        > connection
          |> find_user()
          |> view()
          |> template()
        ```
        - So, what are these?
        - `find_user`: we get the user's raw information from our database.
        - `view`: we process that information into something that we can display, done via a combination of HTML and Embedded Elixir (Elixir code that can be immediately evaluated in an HTML file, like JavaScript).
        - `template`: we render our `view` -which is just converted to raw HTML after it gets loaded- onto a larger HTML file (or *template*). 
          - Where a  `view` just has the code pertaining to the information we're requesting, the `template` has everything else on the web page: header, nav-bar, footer, etc. 
          - A `template` is persistent and doesn't change, it just has holes to put code from the `view` into.
          - Using a `template` makes life easier, as it lets us keep a consistent style, and it means that we don't need to create an entire new web-page from scratch for every different bit of information we want to show. Say we wanted to add a new item to our nav-bar, we would only need to do it once on our `template` and it will apply everywhere, instead of manually adding the new item on every possible existing web-page. 
          - You may very well have more than one `template` per website, but the ratio of `template`'s to `view`'s should be very low.  