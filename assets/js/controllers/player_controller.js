import { Controller } from "stimulus"

export default class extends Controller {
    static values = {
        title: String,
        path: String,
        album: String,
        artist: String
    }

    static targets = ["test" ]

    titleValueChanged(){
    }
    
    play() {
        let path = this.pathValue.slice(12)
        let player = document.querySelector("#player")
        player.src = path
    }
}
