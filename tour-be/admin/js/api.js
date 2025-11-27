// admin/js/api.js
const BASE_API = "http://localhost:3000/api";

const API = {
  TOUR_TYPES: `${BASE_API}/tour-types/tour_type`,
  TOUR_CATEGORIES: `${BASE_API}/tour-categories`,
  TOURS: `${BASE_API}/tours`,
  TOUR_PRICES: `${BASE_API}/tour-prices`,
  PROFILE: `${BASE_API}/profile`,
  USERS_ALL: `${BASE_API}/profile/all`,
  TOUR_IMAGES: `${BASE_API}/tour-images`,
  TOUR_LOCATIONS: `${BASE_API}/tour-locations`,
  TOUR_GUIDES: `${BASE_API}/tour-guides`,
  TOUR_GUIDE_ASSIGNMENT: `${BASE_API}/tour-guide-assignment`,
  TOUR_SCHEDULES: `${BASE_API}/tour-schedules`,
  ORDERS: `${BASE_API}/orders`,
  PAYMENTS: `${BASE_API}/payments`,
};
