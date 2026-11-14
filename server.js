
require("dotenv").config();

const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const path = require("path");

const { pool, testConnection } = require("./config/db");

const app = express();

const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan("dev"));

// Serve frontend files
app.use(express.static(path.join(__dirname, "public")));

// Welcome route
app.get("/api", (req, res) => {
    res.json({
        success: true,
        message: "Online Doctor Appointment System API"
    });
});

// Health check route
app.get("/api/health", async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT NOW() AS currentTime");

        res.status(200).json({
            success: true,
            message: "Server and database are working!",
            database: "Connected",
            time: rows[0].currentTime
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Database connection error"
        });
    }
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: "Route not found"
    });
});

// Start server
async function startServer() {
    try {
        await testConnection();

        app.listen(PORT, () => {
            console.log("--------------------------------");
            console.log("Online Doctor Appointment System");
            console.log(`Server running at http://localhost:${PORT}`);
            console.log("--------------------------------");
        });

    } catch (error) {
        console.error("Server startup failed.");
        process.exit(1);
    }
}

startServer();
