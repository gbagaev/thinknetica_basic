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

  def options
    command = nil
    while command != '0'
      show_main_menu
      command = gets.chomp
      case command
        when '1' then create_station
        when '2' then create_train
        when '3' then route_management
        when '4' then route_for_train
        when '5' then add_wagon
        when '6' then remove_wagon
        when '7' then move_train
        when '8' then stations_and_trains_list
        when '0' then nil
        else
          puts "Command #{command} is incorrect!"
      end
    end
  end

  private

  def show_main_menu
    puts 'Available options:
     ================================
     1. Create a station
     2. Create a train
     3. Route management
     4. Assign a route to the train
     5. Add a wagon
     6. Remove the wagon
     7. Move the train
     8. List of stations and trains
     ================================
     0. Exit the menu
     ================================'
    puts 'Enter the command number:'
  end

  def create_station
    station = create_station!
    return unless station

    stations << station
    puts "You created the station: '#{station.name}'"
    station
  end

  def create_station!
    puts 'Enter the station name: '
    name = gets.chomp
    Station.new(name)
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def create_train
    train = create_train!
    return unless train

    trains << train
    puts "You selected the train: '#{train.type}' № '#{train.number}'"
    train
  end

  def create_train!
    type = select_train_type
    puts 'Enter the train number: '
    number = gets.chomp
    if type == 'p'
      PassengerTrain.new(number)
    elsif type == 'c'
      CargoTrain.new(number)
    end
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def select_train_type
    puts 'Select the type of train:'
    puts " - enter 'p' if you want passenger"
    puts " - enter 'c' if you want cargo"
    type = gets.chomp
    while type != 'p' && type != 'c'
      puts 'You have chosen a nonexistent type! Please, select correct type:'
      type = gets.chomp
    end
    type
  end

  def route_management
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
    puts 'Enter the command number:'
  end

  def create_route
    if stations.count < 2
      puts "You need at least 2 stations to create route. You already have #{stations.count}"
    else
      route = create_route!
      return unless route

      routes << route
      route
    end
  end

  def create_route!
    puts 'Select first station of the route'
    first = select_station
    puts 'Select last station of the route'
    last = select_station
    Route.new(first, last)
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def select_station(stations_to_select_from = nil)
    stations_to_select_from ||= stations
    if stations_to_select_from.empty?
      puts 'You have no stations!'
    else
      puts 'Available stations:'
      stations_to_select_from.each { |station| puts station.name }
      puts 'Type station name:'
      name = gets.chomp
      stations_to_select_from.find { |station| station.name == name }
    end
  end

  def add_station_to_route
    route = select_route
    return unless route
    puts 'Select station to add to the route'
    route.add_station(select_station)
  end

  def remove_station_from_route
    route = select_route
    return unless route
    station = select_station(route.stations)
    route.remove_station(station)
  end

  def select_route
    if routes.empty?
      puts 'You have not route!'
    else
      number = get_route_index
      route = routes[number]
      if route
        route
      else
        puts "No route with number '#{number}'"
      end
    end
  end

  def get_route_index
    puts 'Available routes:'
    routes.each_with_index do |route, index|
      puts "#{index} - #{route.to_s}"
    end
    puts 'Type route number:'
    gets.chomp.to_i
  end

  def route_for_train
    train = select_train
    return unless train

    route = select_route
    train.route = route if route
  end

  def select_train
    if trains.empty?
      puts 'You have no trains'
    else
      number = get_train_number
      train = trains.find { |train| train.number == number }
      return train if train
      puts "You have no train with number #{number}"
    end
  end

  def get_train_number
    puts 'Available trains:'
    trains.each { |train| puts "'#{train.type}' № '#{train.number}'" }
    puts 'Select train number:'
    gets.chomp
  end

  def add_wagon
    train = select_train
    return unless train
    wagon = create_wagon(train.type)
    train.add_wagon(wagon)
    puts "Wagon added to #{train.type} train #{train.number}"
  end

  def create_wagon(type)
    if type == 'passenger'
      PassengerWagon.new
    else
      CargoWagon.new
    end
  end

  def remove_wagon
    train = select_train
    return unless train
    wagon = select_wagon_to_delete(train)
    train.remove_wagon(wagon)
    puts 'You removed wagon'
  end

  def select_wagon_to_delete(train)
    if train.wagons.empty?
      puts "You have no wagons in train: '#{train.type}' № '#{train.number}'"
    else
      puts 'Select wagon you want to delete:'
      train.wagons.each_with_index { |_wagon, index| puts "wagon #{index + 1}" }
      puts 'Select wagon by number:'
      number = gets.chomp.to_i
      wagon = train.wagons[number - 1]
      return wagon if wagon
      puts "No wagon with number '#{number}'"
    end
  end

  def move_train
    train = select_train
    return unless train

    if train.route
      move_train!(train)
    else
      puts 'Train has no route'
    end
  end

  def move_train!(train)
    puts "type: 'f' to move forward, 'b' to move backward"
    answer = gets.chomp
    while answer != 'f' && answer != 'b'
      puts 'You have chosen wrong answer! Please, enter correct answer:'
      answer = gets.chomp
    end
    train.go_forward if answer == 'f'
    train.go_back if answer == 'b'
  end

  def stations_and_trains_list
    puts 'Stations list:'
    stations.each { |station| puts "'#{station.name}'" }
    puts 'Trains list:'
    trains.each { |train| puts "'#{train.type}' № '#{train.number}'" }
  end
end

program = Main.new
program.options
