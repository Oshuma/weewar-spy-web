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
  @report = Spy.debrief(@game)
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
          %p== Name: #{SpyConfig['username']}
          %p== Server: #{SpyConfig['server']}
        = yield

@@ index
%h2 Games
#games
  - @games.each do |id, name|
    .game{:id => id}
      %a{:href => "/game/#{id}"}= name

@@ game
%h2= @game.name
%p
  %a{:href => '/'} Headquarters
#game
  Report:
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

#header h1
  :text-align center

#container
  :margin 0 auto
  :width 700px
