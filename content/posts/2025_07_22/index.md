# Tuesday 22 July 2025

## Boot.dev

I continued the [Learn Memory Management in C](https://www.boot.dev/courses/learn-memory-management-c) on [Boot.dev](https://www.boot.dev/). It was going really well, and once I made it to 3000 XP for the day (without using potions) I decided to call it a day. So far the course mostly feels like revision of what I studied in [CS50](https://github.com/joshkgarber/review50).

I also received more information about the upcoming hackathon. What caught my eye was that for the judging process the project needs to take no more than 5 minutes to install locally. I had to make sure that I could make this work, so I did a quick proof-of-concept. I realized that this would be a good opportunity to practice using `uv`. I created a proof-of-concept using the following steps:

- Initialized a `uv` project.
- Added `flask` as a dependency.
- Wrote a very simple "hello world" app in `app.py`.
- Ran `uv build`.
- Pushed the repo to GitHub.

Then, I used the GitHub documentation to learn about how to create releases. It all worked out and I documented both methods: cloning the repo or installing from `.whl`. I also plan on copying that documentation to this blog at a later date.

## InContext

I made my first commits in over a month. That's because I decided to learn SQLAlchemy so that I'll be able to implement Flask-Permissions to handle access to managing master agents. But what I realized is that at this stage I don't need to block myself. I think that that the benefits to using an ORM outweight the costs for this project at the moment, and I'll implement it in the future. Also, the Flask-Permissions extension isn't part of the Pallets Ecosystem (not that that's necessarily a bad thing but perhaps it shows that it's not as reliable). Right now all I need is two user roles and a way to block one from accessing certain routes. I figured that this project doesn't need an extension for that (at least for now). I'm reminded of the idea that you should focus on the problem you're solving now -- the code you're writing now -- not problems or code you think you might have to write in the future. You'll cross that bridge when you come to it. So, I came up with a way to handle admin/non-admin which perfectly satisfies the requirements for the current project [Masters with Agents](https://github.com/joshkgarber/masters-with-agents). I added a boolean column `admin` to the table `users` to represent the admin role setting and ensured that the admin user which gets created upon database initialization receives that role. Then I created a new wrapper `@admin_only` which can be added to any route. The wrapper checks if the user has the admin role, and if not, aborts the request with a `403` status code. I modeled it off the `@login_required` wrapper function.

I finished all of the progressions on [Masters with Agents](https://github.com/joshkgarber/masters-with-agents). I did so mainly with the solution I mentioned above, but also by removing a couple of progressions from the list which I deemed to be unnecessary at this stage. They were nice-to-haves like breaking and re-instating inheritance on tethered agents. While I do see such features as good ideas, getting the app off the ground and into the hands of other people for feedback is a higher priority.

Having finished all the progressions, I started writing the [tests](https://github.com/joshkgarber/masters-with-agents/tree/main/tests) for [Masters with Agents](https://github.com/joshkgarber/masters-with-agents).

## Web Components

I rekindled my joy of working with [autonomous custom elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements). I don't think I can describe succinctly why I enjoy working with [custom web components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) so much. It just feels so good to be back at it again!

I started a project called [lutenant](https://github.com/joshkgarber/lutenant) (working title) which will showcase my work via the creation of a component library. The idea is to create custom web components for InContext and other future apps. I aim to focus first on tables and cards.

I see this working really well as a complement to a templating tool like Jinja. You would do some basic rendering on the server side to insert the components with a simple HTML tag. For example, with the tag `&lt;lut-table data-spec="{{ table_spec }}">&lt;/lut-table>`, the table will create itself on the front end using information found in `table_spec` which can include fetching data from the server. I haven't figured out exactly what `table_spec` is, but it could include:

- all of the table data, or
- some of the table data, or
- none of the table data, but rather information needed to query the table data from a dedicated route on the server.

The solution I use at first will be designed specifically for InContext. Maybe it will involve having the component fetch the table data from a new route on the blueprint called `tabledata`. For example:

```py
@bp.route("/tabledata", methods=("GET",))
@login_required
def tabledata():
    ...
    return tabledata
```

The best way to use fetch and JSON with Flask is documented [here](https://flask.palletsprojects.com/en/stable/patterns/javascript/). I plan to use this as a reference when it comes to integrating lutenant with InContext.

## Gratitude

I'm grateful for the freedom to pursue programming as a profession. It's something that I've always gravitated towards, and I've always enjoyed it, and had an immense amount of fun doing it.
