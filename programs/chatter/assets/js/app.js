// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket, Presence} from "phoenix"

let user = document.getElementById("user").innerText
let socket = new Socket("/socket", {params: {user: user}})
socket.connect()

let presences = {}

let formattedTimestamp = (Ts) => {
    let date = new Date(Ts)
    return date.toLocaleString()
}

let listBy = (user, {metas: metas}) => {
    return {
        user: user,
        onlineAt: formattedTimestamp(metas[0].onlineAt)
    }
}

let userList = document.getElementById("userList")
let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
        .map(presences => `
        <li>
            ${presence.user}
            <br>
            <small>online since ${presence.onlineAt}</small>
        </li>
        `)
        .join("")
}

let room = socket.channel("room:lobby")
room.on("presence_state", state => {
    presence = Presence.syncState(presences, state)
    render(presences)
})

room.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
})

room.join()