# WeewarSpy Web
%w{
  rubygems
  sinatra
  haml
  yaml
}.each {|dependency| require dependency}

# Load the vendor'ed weewar-spy library.
require File.dirname(__FILE__) + '/vendor/weewar-spy/lib/weewar-spy'

# Load the Operative.
require File.dirname(__FILE__) + '/lib/operative'

configure do
  Title = 'WeewarSpy Web'

  # Load the Weewar configuration.
  config_file = File.dirname(__FILE__) + '/config.yml'
  raise 'Cannot find config.yml' unless File.exists?(config_file)
  SpyConfig = YAML.load_file(config_file)

  # Create an operative.
  options = {:server   => SpyConfig['server'],
             :username => SpyConfig['username'],
             :api_key  => SpyConfig['api_key'] }
  Spy = Operative.new(options)
end

get '/' do
  @games = Spy.games
  haml :index
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/game/:id' do
  @game = Spy.infiltrate(params[:id].to_i)
  @report = Spy.debrief(@game, false) # Don't print the output, just return it.
  haml :game
end

use_in_file_templates!

__END__

@@ layout
!!!
%html
  %head
    %title= Title
    %link{:rel => 'stylesheet', :href => '/styles.css', :type => 'text/css'}
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html'}

  %body
    #container
      #header
        %h1= Title
      #main
        %h2 Spy Details
        #spy-details
          %p== Player: #{SpyConfig['username']}
          %p== Server: #{SpyConfig['server']}
        = yield


@@ index
#games
  %h2 Games
  - @games.each do |id, name|
    .game{:id => id}
      %a{:href => "/game/#{id}"}= name


@@ game
#menu
  %a{:href => '/'} Headquarters
%h2= @game.name
#game
  %pre= @report


@@ stylesheet
html
  :margin 0
  :padding 0

body
  :font
    :family "Helvetica", "Arial", sans-serif
  :margin-left 2.6em
  :margin-top 1.8em
  :margin-bottom 1em
  :margin-right 1em

#container
  :margin 0 auto
  :width 700px

#header h1
  :margin 10px 0
  :text-align center

#main h2
  :margin 0

#main
  #spy-details p
    :margin 5px 0

#menu
  :margin 10px 0
  :padding 10px 0
  a
    :background-color #ccc
    :color #333
    :text-decoration none
    :padding 0.5em
    &:hover
      :background-color #333
      :color #ccc

#games h2
  :margin-top 1em
  :margin-bottom 0.5em
#games div
  :margin 10px 0
#games a
  :border-bottom 1px dashed #333
  :color #333
  :text-decoration none
  &:hover
    :border-bottom 1px solid #333

#game pre
  :background-color #eee
  :border 1px dashed black
  :margin 0.5em
  :padding 0.75em
