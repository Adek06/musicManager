import { Controller } from "stimulus"

export default class extends Controller {
    static values = {
        title: String,
        path: String,
        album: String,
        artist: String
    }

    play() {
        let path = this.pathValue.slice(12)
        let player_audio = document.querySelector("#player_audio")
        player_audio.src = path

        let title = this.titleValue
        let player_title = document.querySelector("#player_title")
        player_title.innerHTML = title
    }
}
