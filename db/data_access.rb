def run_sql(sql, params = [])
    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'wikisolo'})
    results = db.exec_params(sql, params)
    db.close
    return results
end


def find_user_by_email(email)
    results = run_sql("SELECT * FROM users WHERE email = $1;", [email])
    return results[0]
end


def find_user_by_id(id)
    results = run_sql("SELECT * FROM users WHERE user_id = $1;", [id])
    return results[0]
end


def find_post_by_id(id)
    results = run_sql("SELECT * FROM posts WHERE post_id = $1;", [id])
    return results[0]
end

def find_post_by_artist(artist)
    results = run_sql("SELECT * FROM posts WHERE artist = $1;", [artist])
    return results
end


def all_posts()
    run_sql("SELECT * FROM posts;")
end


def create_post(artist, track, genre, instrument, year, solo_start, youtube_url, soloist, user_id)
    sql = "INSERT INTO posts (artist, track, genre, instrument, year, solo_start, youtube_url, soloist, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);"
    run_sql(sql, [artist, track, genre, instrument, year, solo_start, youtube_url, soloist, user_id])
end


def delete_post(id)
    sql = "DELETE FROM posts WHERE post_id = $1;"
    run_sql(sql, [id])
end


def update_post(id, artist, track, genre, instrument, year, solo_start, soloist)

    sql = "UPDATE posts SET artist = $1, track = $2, genre = $3, instrument = $4, year = $5, solo_start = $6, soloist = $7 WHERE post_id = $8;"
    run_sql(sql, [artist, track, genre, instrument, year, solo_start, soloist, id])
end

