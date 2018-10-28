class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params[:room_id]}"
  end
  
  def unsubscribed
  end
  
  def speak(data)
    from_player = Player.find_by(id: data['from_id'].to_s)
    to_player = Player.find_by(id: data['to_id'].to_s)
    from_player.send_message(to_player, data['room_id'], data['content'])
  end
end
