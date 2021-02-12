import { Controller } from "stimulus"
import APlayer from 'APlayer';

export default class extends Controller {
    static values = {
        title: String,
        path: String,
        album: String,
        artist: String
    }

    play() {
        let path = this.pathValue.slice(12)
        console.log(this.artistValue)
        const ap = new APlayer({
            container: document.getElementById('aplayer'),
            audio: [{
                name: this.titleValue,
                artist: this.artistValue,
                url: path,
                cover: 'cover.jpg'
            }]
        });
        ap.play()
    }
}