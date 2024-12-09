FROM --platform=linux/amd64 alpine:3.20

RUN echo "y" | apk add alpine-sdk nasm bash valgrind \
	ncurses openssh clang mandoc man-pages

WORKDIR /app

COPY . .

CMD ["bash"]