// music_controller.js
import { Controller } from "stimulus"
import "axios"
import axios from "axios"
let OSS = require('ali-oss')



export default class extends Controller {
    static targets = [ "name", "output", "musicFile" ]
    test() {
        console.log("test")
        var csrf = document.querySelector("meta[name=csrf]").content;

        axios.post('/music', {
            name: 'test',
            url: 'test url'
        },
        {
            headers: {
                "X-CSRF-TOKEN": csrf
            }
        })
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
