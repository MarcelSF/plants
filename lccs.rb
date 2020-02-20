CODING THE DATA BRICK
# create the Tag
rails g model Tag name
# create the Join Model
rails g model plant_tag plant:references tag:references

# plant.rb
has_many :plant_tags, dependent: :destroy
has_many :tags, through: :plant_tags

# tag.rb
has_many :plant_tags, dependent: :destroy
has_many :plants, through: :plant_tags

# Tag Seed

Tag.destroy_all if Rails.env.development?

names = %w(Fruit\ tree Cactus Greasy\ plant Flower Ferns Conifers)

names.each do |name|
  Tag.create!(name: name)
end

ROUTING

  resources :plants, only: [] do
    resources :plant_tags, only: [ :new, :create ]
  end

CREATE PLANT_TAGS controller

  rails g controller plant_tags

CREATE PLANT_TAGS NEW METHOD

  def new
    @plant = Plant.find(params[:plant_id])
    @plant_tag = PlantTag.new
  end


CREATE FORM FOR NEW PLANT TAG

  <div class="container">
    <div class="row justify-content-center">
      <div class="col-12 col-md-8">
        <h1>Add new tag for <%= @plant.name %></h1>

        <%= simple_form_for [ @plant, @plant_tag ] do |f| %>
          <%= f.input :tag, collection: Tag.all %>
          <%= f.submit "Add tag", class: 'btn btn-primary' %>
        <% end %>
      </div>
    </div>
  </div>

CREATE METHOD FOR PLANT_TAGS controller

  def create
    @plant = Plant.find(params[:plant_id])
    @tag = Tag.find(params[:plant_tag][:tag])
    @plant_tag = PlantTag.new(plant: @plant, tag: @tag)
    @plant_tag.save
    redirect_to garden_path(@plant.garden)
  end

TAGS DISPLAY ON PLANT CARD!

  <div class="card-tags">
    <% plant.tags.each do |tag| %>
      <span><%= tag.name %></span>
    <% end %>
    <%= link_to "+", new_plant_plant_tag_path(plant) %>
  </div>

VALIDATE TAG
  # plant_tag.rb
  validates :tag, uniqueness: { scope: :plant,
    message: "already added" }

UPDATE PLANT_TAG controller

  # [...]
if @plant_tag.save
  redirect_to garden_path(@plant.garden)
else
  render :new
end

BUGFIX

  def create
    @plant = Plant.find(params[:plant_id])
    @tags = Tag.where(id: params[:plant_tag][:tag])
    @tags.each do |tag|
      plant_tag = PlantTag.new(plant: @plant, tag: @tag)
      plant_tag.save
    end
    redirect_to garden_path(@plant.garden)
  end

ADDING SELECT2 and jquery
 yarn add select2 jquery

CONFIGURATION (add the multiple-select class to your select input)

# in -> app/javascript/components/select.js

import $ from 'jquery';
import select2 from 'select2';

const multipleSelect = () => {
  $(document).ready(function() {
    $('.multiple-select').select2();
  });
}

export { multipleSelect };

IMPORTING SELECT2 # in -> app/javascript/packs/application.js

import 'select2/dist/css/select2.css'; // <-- you'll need to uncomment the stylesheet_pack_tag in the layout /!\

import { multipleSelect } from "../components/select";

multipleSelect();
