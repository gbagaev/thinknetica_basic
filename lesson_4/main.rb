require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Main
  attr_reader :trains, :routes, :stations

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

  def show_main_menu
    puts '    Available options:
     ================================
     1. Create a station
     2. Create a train
     3. Route management
     4. Assign a route to the train
     5. Add a wagon
     6. Unhook the wagon
     7. Movement of the train
     8. List of stations and trains
     ================================
     0. Exit the menu
     ================================'
    puts '    Enter the command number:'
  end

  def options
    command = nil
    while command != '0'
      show_main_menu
      command = gets.chomp
      case command
      when '1' then create_station
      when '2' then create_train
      when '3' then route_management
      when '4' then route_to_train
      when '5' then add_wagon
      when '6' then remove_wagon
      when '7' then move_train
      when '8' then stations_and_trains_list
      when '0' then
      else
        puts "Command #{command} is incorrect!"
        '========================================'
      end
    end
  end

  private

  def create_station
    print 'Enter the station name: '
    name = gets.chomp
    station = Station.new(name)
    stations << station
    puts '===================================='
    puts " You created the station: '#{name}'"
    puts '===================================='
    station
  end

  def create_train
    puts 'Select the type of train:'
    puts '-----------------------------------'
    puts "1. enter 'p' if you want passenger"
    puts "2. enter 'c' if you want cargo"
    puts '-----------------------------------'
    type = gets.chomp
    print 'Enter the train number: '
    number = gets.chomp
    while type != 'p' && type != 'c'
      puts 'You have chosen a nonexistent type!'
      puts 'Please, select correct type:'
      type = gets.chomp
    end
    train = if type == 'p'
      PassengerTrain.new(number)
    elsif type == 'c'
      CargoTrain.new(number)
    end
    trains << train
    type = 'passenger' if type == 'p'
    type = 'cargo' if type == 'c'
    puts '================================================='
    puts " You selected the train: '#{type}' № '#{number}'"
    puts '================================================='
    train
  end

  def route_management
    puts
    show_route_menu
    route_option = gets.chomp
    case route_option
      when '1' then create_route
      when '2' then add_station_to_route
      when '3' then remove_station_from_route
      when '0' then nil
      else
        puts "Command #{route_option} is incorrect!"
    end
  end

  def show_route_menu
    puts '    Available options:
     ====================================
     1. Create a route
     2. Add the station to the route
     3. Remove the station from the route
     ====================================
     0. Return to main menu
     ===================================='
    puts '    Enter the command number:'
  end

  def create_route
    if stations.count < 2
      puts 'You need at least 2 stations to create route'
      puts "You already have #{stations.count}"
      puts '----------------------------------------------'
      puts 'Type anything and hit ENTER to create station.'
      puts 'To go to main menu - just hit ENTER'
      puts '----------------------------------------------'
      answer = gets.chomp
      if answer.length > 0
        create_station
        create_route
      end
    else
      puts 'select first station of the route'
      first = select_station
      puts 'select last station of the route'
      last = select_station
      route = Route.new(first, last)
      routes << route
      route
    end
  end

  def ask_to_select_station
    puts 'Type anything and hit ENTER to select station.'
    puts 'To go to main menu - just hit ENTER'
    answer = gets.chomp
    if answer.length > 0
      select_station
    end
  end

  def select_station!
    puts 'Available stations:'
    stations.each { |station| puts "'#{station.name}'" }
    puts 'Select station:'
    name = gets.chomp
    station = stations.find { |station| station.name == name }
    station || puts("There is no station '#{name}'")
  end

  def ask_to_create_station
    puts 'You have not any station'
    puts '------------------------------------------------------------------'
    puts 'Type anything and hit ENTER to create station, else just hit Enter'
    puts '------------------------------------------------------------------'
    answer = gets.chomp
    if answer.length > 0
      create_station
    end
  end

  def select_station(stations_to_select_from = nil)
    stations_to_select_from ||= stations
    station = select_station!
    if station
      station
    else
      ask_to_select_station
    end
  end

  def add_station_to_route
    route = if routes.empty?
              ask_to_create_route
            else
              select_route
            end
    return unless route
    puts 'Select station to add to the route'
    station = select_station
    return unless station
    route.add_station(station)
  end

  def remove_station_from_route
    if routes.empty?
      puts 'You have not any route'
      return
    end
    route = select_route
    return unless route
    station = select_station(route.stations)
    route.remove_station(select_station)
  end

  def select_route
    if routes.empty?
      ask_to_create_route
    else
      select_route!
    end
  end

  def select_route!
    puts 'Available routes:'
    routes.each_with_index do |route, index|
      puts "#{index} - #{route.to_s}"
    end
    puts 'Select route by number:'
    number = gets.chomp.to_i
    route = routes[number]
    route || puts("No route with number '#{number}'")
  end

  def ask_to_create_route
    puts 'You have not any route'
    puts '----------------------------------------------------------------'
    puts 'Type anything and hit ENTER to create route, else just hit Enter'
    puts '----------------------------------------------------------------'
    answer = gets.chomp
    if answer.length > 0
      create_route
    end
  end

  def ask_to_select_route
    puts 'Type anything and hit ENTER to select route.'
    puts 'To go to main menu - just hit ENTER'
    answer = gets.chomp
    if answer.length > 0
      select_route
    end
  end

  def route_to_train
    train = if trains.empty?
              ask_to_create_train
            else
              select_train
            end
    return unless train
    route = select_route
    train.route = route if route
  end

  def select_train
    train = select_train!
    if train
      train
    else
      ask_to_select_train
    end
  end

  def select_train!
    puts 'Available trains:'
    trains.each { |train| puts "'#{train.type}' № '#{train.number}'" }
    puts 'Select train number:'
    number = gets.chomp
    train = trains.find { |train| train.number == number }
    train || puts("There is no train with number '#{number}'")
  end

  def ask_to_select_train
    puts 'Type anything and hit ENTER to select train.'
    puts 'To go to main menu - just hit ENTER'
    answer = gets.chomp
    if answer.length > 0
      select_train
    end
  end

  def ask_to_create_train
    puts 'You have not any train'
    puts '----------------------------------------------------------------'
    puts 'Type anything and hit ENTER to create train, else just hit Enter'
    puts '----------------------------------------------------------------'
    answer = gets.chomp
    if answer.length > 0
      create_train
    end
  end

  def add_wagon
    train = if trains.empty?
              ask_to_create_train
            else
              select_train
            end
    return unless train
    wagon = if train.type == 'passenger'
              PassengerWagon.new
            else
              CargoWagon.new
            end
    train.add_wagon(wagon)
    puts "Wagon added to train with number: #{train.number}"
    puts
  end

  def remove_wagon
    train = if trains.empty?
              puts '====================='
              puts " You have not trains!"
              puts '====================='
              puts
            else
              select_train
            end
    return unless train
    puts 'Select wagon witch you want to delete:'
    if train.wagons.empty?
      puts 'Train has not wagons to delete!'
    else
      wagon = select_wagon(train)
      train.remove_wagon(wagon)
    end
  end

  def select_wagon(train)
    if train.wagons.empty?
      puts "You have no wagons in train: '#{train.type}' № '#{train.number}'"
    else
      select_wagon!(train.wagons)
    end
  end

  def select_wagon!(wagons)
    puts 'Available wagons:'
    wagons.each_with_index do |wagon, index|
      puts "Wagon - #{index}"
    end
    puts 'Select wagon by number:'
    number = gets.chomp.to_i
    wagon = wagons[number]
    puts "You deleted wagon № '#{number}'"
    puts
    wagon || puts("No wagon with number '#{number}'")
  end

  def move_train
    train = if trains.empty?
              puts '====================='
              puts " You have not trains!"
              puts '====================='
              puts
            else
              select_train
            end
    return unless train
    if train.route
      puts 'You want move train forward or backward?'
      puts '---------------------------------------'
      puts "1. enter 'f' if you want move forward"
      puts "2. enter 'b' if you want move backward"
      puts '---------------------------------------'
      answer = gets.chomp
      while answer != 'f' && answer != 'b'
        puts 'You have chosen wrong answer!'
        puts 'Please, enter correct answer:'
        answer = gets.chomp
      end
      if answer == 'f'
        train.go_forward
      elsif answer == 'b'
        train.go_back
      end
    else
      puts 'Train has no route'
    end
  end

  def stations_and_trains_list
    puts 'Stations list:'
    stations.each do |station|
      puts "Station name '#{station.name}'"
    end
    puts
    puts 'Trains list:'
    trains.each  do |train|
      puts "'#{train.type}' № '#{train.number}'"
    end
    puts
  end
end

program = Main.new

program.options
