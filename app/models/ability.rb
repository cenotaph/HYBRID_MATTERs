class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
      can :destroy, User
      can :manage, Pressrelease
    elsif user.has_role? :partner
      can :manage, Submission
      can :manage, Call
      can :manage, Comment
      can :manage, Vote
      can :manage, Post
      can :manage, Event
      can :manage, Artist
      can :manage, Work

      can :manage, Page
      can :manage, user
      cannot :manage, Project
      cannot :manage, Subsite
    elsif user.has_role? :reviewer
      #  can read submissions on the tokyo one
      # can create comments and votes
      can :read, Call do |call|
        user.calls.include?(call)
      end
      can :read, Submission do |sub|
        user.calls.include?(sub.call)
      end
      can :manage, Vote do |vote|
        user.calls.include?(vote.submission.call)
      end
      can :manage, Comment, user_id: user.id

    elsif user.has_role? :resident
      can :read, Node, id: '58a8ccd0cbbb983e2b597fa9'
      can :read, Project, id: '58a8d22fcbbb985887fe8820'
      can :read, User, id: user.id
      can :create, Post, node_id: '58a8ccd0cbbb983e2b597fa9', project_ids: ['58a8d22fcbbb985887fe8820'], user_id: user.id
      can :manage, Post,  user_id: user.id

    elsif user.has_role? :participant
      can :manage, Post # lock to Field_notes only -- to be done
      cannot :manage, Artist
    else
      cannot :read, :all

    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
