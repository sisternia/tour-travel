// services/auth.service.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return await bcrypt.hash(password, salt);
};

const comparePassword = async (password, hashedPassword) => {
  return await bcrypt.compare(password, hashedPassword);
};

const generateToken = (payload) => {
  return jwt.sign(payload, process.env.JWT_SECRET || 'secret', { expiresIn: '7d' });
};

module.exports = { hashPassword, comparePassword, generateToken };
