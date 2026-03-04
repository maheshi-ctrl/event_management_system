from flask import Flask, request, jsonify
import json
from flask_cors import CORS   # <-- add this

app = Flask(__name__)
CORS(app)  # <-- enable CORS for all routes

# -------- LOGIN --------
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get("email")
    password = data.get("password")

    with open('users.json') as f:
        users = json.load(f)

    for user in users:
        if user["email"] == email and user["password"] == password:
            return jsonify({
                "id": user["id"],
                "name": user["name"],
                "email": user["email"],
                "role": user["role"]
            })

    return jsonify({"message": "Invalid credentials"}), 401


# -------- GET EVENTS --------
@app.route('/events', methods=['GET'])
def get_events():
    with open('events.json') as f:
        events = json.load(f)
    return jsonify(events)


# -------- ADD EVENT --------
@app.route('/events', methods=['POST'])
def add_event():
    new_event = request.json
    role = new_event.get("role")

    if role != "admin":
        return jsonify({"message": "Unauthorized"}), 403

    with open('events.json') as f:
        events = json.load(f)

    new_event['id'] = len(events) + 1
    events.append({
        "id": new_event['id'],
        "title": new_event.get("title"),
        "description": new_event.get("description"),
    })

    with open('events.json', 'w') as f:
        json.dump(events, f, indent=4)

    return jsonify({"message": "Event added successfully"})


# -------- UPDATE EVENT --------
@app.route('/events/<int:event_id>', methods=['PUT'])
def update_event(event_id):
    data = request.json
    role = data.get("role")

    if role != "admin":
        return jsonify({"message": "Unauthorized"}), 403

    with open('events.json') as f:
        events = json.load(f)

    for event in events:
        if event["id"] == event_id:
            event["title"] = data.get("title", event["title"])
            event["description"] = data.get("description", event["description"])

            with open('events.json', 'w') as f:
                json.dump(events, f, indent=4)
            return jsonify({"message": "Event updated successfully", "event": event})

    return jsonify({"message": "Event not found"}), 404


# -------- DELETE EVENT --------
@app.route('/events/<int:event_id>', methods=['DELETE'])
def delete_event(event_id):
    data = request.json
    role = data.get("role")

    if role != "admin":
        return jsonify({"message": "Unauthorized"}), 403

    with open('events.json') as f:
        events = json.load(f)

    updated_events = [event for event in events if event["id"] != event_id]

    if len(updated_events) == len(events):
        return jsonify({"message": "Event not found"}), 404

    with open('events.json', 'w') as f:
        json.dump(updated_events, f, indent=4)

    return jsonify({"message": "Event deleted successfully"})


# -------- RSVP --------
@app.route('/rsvp', methods=['POST'])
def rsvp():
    data = request.json
    event_id = data.get("event_id")
    student_id = data.get("student_id")

    if not event_id or not student_id:
        return jsonify({"message": "Missing event_id or student_id"}), 400

    with open('rsvp.json') as f:
        rsvp_data = json.load(f)

    # Always append RSVP (duplicates allowed)
    rsvp_data.append({"event_id": event_id, "student_id": student_id})

    with open('rsvp.json', 'w') as f:
        json.dump(rsvp_data, f, indent=4)

    return jsonify({"message": "RSVP successful"})


# -------- VIEW ALL RSVPs --------
@app.route('/rsvp', methods=['GET'])
def view_rsvp():
    with open('rsvp.json') as f:
        rsvp_data = json.load(f)
    return jsonify(rsvp_data)


# -------- VIEW RSVPs BY EVENT (ENRICHED) --------
@app.route('/events/<int:event_id>/rsvps', methods=['GET'])
def view_rsvp_by_event(event_id):
    with open('rsvp.json') as f:
        rsvp_data = json.load(f)

    with open('users.json') as f:
        users = json.load(f)

    filtered = [r for r in rsvp_data if int(r.get("event_id")) == event_id]

    result = []
    for r in filtered:
        student_id = int(r.get("student_id"))
        student = next((u for u in users if u["id"] == student_id), None)
        if student:
            result.append({
                "id": student["id"],
                "name": student["name"],
                "email": student["email"],
                "role": student["role"]
            })
        else:
            result.append({
                "id": student_id,
                "name": "Unknown",
                "email": None,
                "role": "student"
            })

    return jsonify(result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)