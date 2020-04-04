require "databrain/version"

module Databrain
  class Error < StandardError; end

  def self.transact!(db, query); end

  def self.q(query, db)
    q_find = []
    _q_in = []
    q_where = []
   
    query = query.dup
    until (t = query.first).nil?
      case query.shift
      when :find
        q_find << query.shift until q_brake(query)
      when :where
        q_where << query.shift until q_brake(query)
      when :in
        raise "Term `in` not implemented yet"
      else
        raise "Wrong term: #{t}"
      end
    end

    eavt(db).reduce([]) do |result, (_e, av)|
      # _e - is entity id
      # av - is a map of attributes and values
      finded = q_where.reduce(q_find.dup) do |find, clause|
        _, a, v = *clause
        if v.is_a?(Symbol) && v[-1] == "?"
          i = find.index(v)
          print "find: #{find}\ni: #{i}\nav: #{av}\na: #{a}\nv: #{v}\n\n"
          find[i] = av[a]
        else
          break if v != av[a]
        end

        find
      end
      result << finded if finded
      result
    end
  end

  def self.eavt(db)
    db.reduce({}) do |idx, (e, a, v)|
      idx[e] ? idx[e][a] = v : idx[e] = { a => v }
      idx
    end
  end

  def self.aevt(db)
    db.reduce({}) do |idx, (e, a, v)|
      idx[a] ? idx[a][e] = v : idx[a] = { e => v }
      idx
    end
  end

  private

  def self.q_brake((nxt, _))
    [nil, :where, :in].include? nxt
  end
end
