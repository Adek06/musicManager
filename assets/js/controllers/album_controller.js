import { Controller } from "stimulus"

export default class extends Controller {
    static values = {
        album: String
    }

    play() {
        let musics = document.querySelectorAll("li[data-controller='music']")
        let play_list = []
        for (let i=0; i<musics.length; i++) {
            let music = musics[i]
            let title = music.getAttribute("data-music-title-value")
            let album = music.getAttribute("data-music-album-value")
            let path = music.getAttribute("data-music-path-value")
            play_list.push({"title": title, "album": album, "path": path})
        }
        
        let current_music = play_list[0]
        let path = current_music.path.slice(12)
        let player_audio = document.querySelector("#player_audio")
        player_audio.src = path

        let player = document.querySelector("#player")
        let musicInfos = {
            "title": current_music.title,
            "album": current_music.album,
        }
        for(let k in musicInfos){
            player.setAttribute(k, musicInfos[k])
        }

        play_list = play_list.splice(1)
        localStorage.setItem('play_list', JSON.stringify(play_list));
    }
}
