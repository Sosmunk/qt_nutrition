function toISODate(date) {
    return date.toISOString().slice(0, 10).toString()
}

function getCurrentISODate() {
    return toISODate(new Date());
}
