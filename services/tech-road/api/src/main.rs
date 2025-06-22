use axum::{
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde_json::json;
use std::net::SocketAddr;
use tower_http::cors::CorsLayer;
use tracing::info;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[tokio::main]
async fn main() {
    // Initialize tracing
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "tech_road_api=debug,tower_http=debug".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    // Load environment variables
    dotenvy::dotenv().ok();

    // Build application
    let app = Router::new()
        .route("/api/v1/health", get(health_check))
        .layer(CorsLayer::permissive());

    // Configure socket address
    let host = std::env::var("HOST").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = std::env::var("PORT").unwrap_or_else(|_| "8000".to_string());
    let addr: SocketAddr = format!("{}:{}", host, port).parse().unwrap();

    info!("Server running on http://{}", addr);

    // Start server
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn health_check() -> (StatusCode, Json<serde_json::Value>) {
    (StatusCode::OK, Json(json!({
        "success": true,
        "data": {
            "status": "healthy",
            "service": "tech-road-api",
            "version": env!("CARGO_PKG_VERSION")
        }
    })))
}
