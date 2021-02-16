const e = React.createElement;
const domID = "player"

class PlayerAudio extends React.Component{
    constructor(props){
        super(props);
        this.test = this.test.bind(this);
    }

    test() {
        alert("next music")
    }

    render() {
        let test = this.test
        return e(
            'audio',
            {id: "player_audio", controls: true, autoPlay:"autoPlay", onEnded:{test}},
            null
        )
    }
}

function PlayerInfo(props) {
    let content = props.content
    return e(
        'span',
        {className: "columns"},
        content
    )
}

class Player extends React.Component {
  constructor(props) {
    super(props);
    this.state = { title: props.title, album: props.album};
    // 选择需要观察变动的节点
    const targetNode = document.querySelector('#'+domID);

    // 观察器的配置（需要观察什么变动）
    const config = { attributes: true };

    self = this
    // 当观察到变动时执行的回调函数
    const callback = function(mutationsList, observer) {
        // Use traditional 'for loops' for IE 11
        let state = {}
        for(let mutation of mutationsList) {
            let value = targetNode.getAttribute(mutation.attributeName)
            let key = mutation.attributeName
            state[key] = value
        }
        self.setState(state)
    };

    // 创建一个观察器实例并传入回调函数
    const observer = new MutationObserver(callback);

    // 以上述配置开始观察目标节点
    observer.observe(targetNode, config);
  }

  nextMusic() {

  }
  
  render() {
    let title = this.state.title
    let album = this.state.album
    return e(
      'div',
      { className: "footer columns" },
      e('div', {className: "column is-one-fifth"}, 
        e(PlayerInfo, {content: title}, null),
        e(PlayerInfo, {content: album}, null)),
      e('div', {className:'column'}, e(PlayerAudio))
    );
  }
}

const domContainer = document.querySelector('#'+domID);
ReactDOM.render(e(Player, {title: "未知", album: "未知"}), domContainer);