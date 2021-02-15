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

        let player = document.querySelector("#player")
        let musicInfos = {
            "title": this.titleValue,
            "album": this.albumValue,
            "artist": this.artistValue
        }
        for(let k in musicInfos){
            player.setAttribute(k, musicInfos[k])
        }
    }
}
