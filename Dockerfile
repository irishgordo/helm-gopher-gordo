FROM rust:1.84.1 AS build
RUN USER=root cargo new --bin gophergordo
WORKDIR /gophergordo
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
RUN cargo build --release --verbose
RUN rm src/*.rs
COPY ./src ./src
RUN rm ./target/release/deps/helm_gordo_gopher*
RUN cargo build --release --verbose
FROM rust:1.84.1-slim
COPY --from=build /gophergordo/target/release/helm-gordo-gopher .
RUN useradd -u 8877 gophergordo
USER gophergordo
EXPOSE 7070:70
CMD ["./helm-gordo-gopher"]