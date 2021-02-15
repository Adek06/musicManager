const e = React.createElement;
const domID = "player"

class PlayerAudio extends React.Component{
    constructor(props){
        super(props);
    }

    render() {
        return e(
            'audio',
            {id: "player_audio", controls: true, autoPlay:"autoPlay"},
            null
        )
    }
}

function PlayerInfo(props) {
    let title = props.title
    return e(
        'span',
        {},
        title
    )
}

class Player extends React.Component {
  constructor(props) {
    super(props);
    this.state = { title: props.title };
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
  
  render() {
    let title = this.state.title
    return e(
      'div',
      { className: "footer columns" },
      e('div', {className: "column is-one-fifth"}, 
        e(PlayerInfo, {title: title}, null),
        e(PlayerInfo, {title: title}, null)),
      e('div', {className:'column'}, e(PlayerAudio))
    );
  }
}

const domContainer = document.querySelector('#'+domID);
ReactDOM.render(e(Player, {title: "未知", album: "未知"}), domContainer);