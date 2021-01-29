// music_controller.js
import { Controller } from "stimulus"
let OSS = require('ali-oss')



export default class extends Controller {
    static targets = [ "name", "output", "musicFile" ]
    test() {
        console.log(this.musicFileTarget)
        console.log(musicFile.id)
        var fileObj = document.getElementById("musicFile").files[0];
        console.log(fileObj)
    }

    upload() {
        let client = new OSS({
            region: 'oss-cn-beijing',
            accessKeyId: '',
            accessKeySecret: '',
            bucket: 'adek06game'
        })
        let file = document.getElementById("musicFile").files[0];
        client.put('testMusic.mp3', file).then(function (r1) {
            console.log('success');
            return client.get('object');
        }).catch(function (err) {
            console.error('error: ', err);
        });
    }

    greet() {
        this.outputTarget.textContent =
            `Hello, ${this.nameTarget.value}!`
    }
}
