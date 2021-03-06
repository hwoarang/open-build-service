module HistoryElement
# This class represents some kind of history element within the build service
  class Base < ActiveRecord::Base
    belongs_to :user

    self.table_name = 'history_elements'

    class << self
      attr_accessor :description, :raw_type
      attr_accessor :comment, :raw_type
      attr_accessor :created_at, :raw_type
    end

    def color
      nil
    end
  end
end

class HistoryElement::Request < ::HistoryElement::Base
  self.description = 'Request was updated'
  self.abstract_class = true

  def request
    BsRequest.find(self.op_object_id)
  end

  def request=(request)
    self.op_object_id = request.id
  end

  def render_xml(builder)
    attributes = {who: self.user.login, when: self.created_at.strftime('%Y-%m-%dT%H:%M:%S')}
    builder.history(attributes) do
      builder.description! self.description
      builder.comment! self.comment unless self.comment.blank?
    end
  end
end

class HistoryElement::RequestCreated < HistoryElement::Request
  def color
    'black'
  end

  def description
    'Request created'
  end
end

class HistoryElement::RequestAccepted < HistoryElement::Request
  def color
    'green'
  end

  def description
    'Request got accepted'
  end
end

class HistoryElement::RequestDeclined < HistoryElement::Request
  def color
    'maroon'
  end

  def description
    'Request got declined'
  end
end

class HistoryElement::RequestRevoked < HistoryElement::Request
  def color
    'green'
  end

  def description
    'Request got revoked'
  end
end

class HistoryElement::RequestSuperseded < HistoryElement::Request
  def color
    'green'
  end

  def description
    desc = 'Request got superseded'
    desc << " by request " << self.description_extension if self.description_extension
    desc
  end

  def initialize(a)
    super
  end
end

class HistoryElement::RequestReviewAdded < HistoryElement::Request
  # self.description_extension is review id
  def description
    'Request got a new review request'
  end
end

class HistoryElement::RequestAllReviewsApproved < HistoryElement::Request
  def color
    'green'
  end

  def description
    'Request got reviewed'
  end
end

class HistoryElement::RequestReopened < HistoryElement::Request
  def color
    'maroon'
  end

  def description
    'Request got reopened'
  end
end

class HistoryElement::RequestSetIncident < HistoryElement::Request
  def color
    'black'
  end

  def description
    'Maintenance target got moved to project ' + self.description_extension
  end
end

class HistoryElement::RequestPriorityChange < HistoryElement::Request
  def color
    'black'
  end

  def description
    'Request got a new priority: ' + self.description_extension
  end
end

class HistoryElement::Review < ::HistoryElement::Base
  self.description = 'Review was updated'
  self.abstract_class = true

  def review
    Review.find(self.op_object_id)
  end

  def request
    Review.find(self.op_object_id).bs_request
  end

  def review=(review)
    self.op_object_id = review.id
  end

  def render_xml(builder)
    attributes = {who: self.user.login, when: self.created_at.strftime('%Y-%m-%dT%H:%M:%S')}
    builder.history(attributes) do
      builder.description! self.description
      builder.comment! self.comment unless self.comment.blank?
    end
  end
end

class HistoryElement::ReviewAccepted < HistoryElement::Review
  def description
    'Review got accepted'
  end
end

class HistoryElement::ReviewDeclined < HistoryElement::Review
  def description
    'Review got declined'
  end
end

class HistoryElement::ReviewReopened < HistoryElement::Review
  def description
    'Review got reopened'
  end
end

class HistoryElement::ReviewAssigned < HistoryElement::Review
  def description
    'Review got assigned'
  end
end
