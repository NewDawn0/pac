const std = @import("std");

pub fn main() !void {
    const arts: [5]Art = .{ PAC, BALLS, GHOSTS[0], GHOSTS[1], GHOSTS[2] };
    const art = comptime mkArt(&arts);
    const stdout = comptime std.io.getStdOut().writer();
    try stdout.writeAll(art);
}

// Helper functions
fn mkArt(comptime arts: []const Art) []const u8 {
    const lns: usize = arts[0].art.len;
    var parts: [lns][]const u8 = undefined;
    inline for (0..lns) |i| {
        parts[i] = comptime mkArtLn(arts, i);
    }
    return comptime join(&parts);
}

fn mkArtLn(comptime arts: []const Art, comptime ln: usize) []const u8 {
    var parts: [arts.len + 2][]const u8 = undefined;
    inline for (0..arts.len) |i| {
        parts[i] = comptime arts[i].getLn(ln);
    }
    parts[arts.len] = COLS.nc;
    parts[arts.len + 1] = "\n";
    return comptime join(&parts);
}

fn getEyeParts(comptime xs: []const u8, comptime x: [2]u8) [5][]const u8 {
    var idx: usize = 0;
    var idxs: [5][2]usize = undefined;
    var out: [5][]const u8 = undefined;
    var lastIdx: usize = 0;
    var idxCount: usize = 0;
    while (idx < xs.len) {
        if (xs[idx] == x[0] or xs[idx] == x[1]) {
            idxs[idxCount] = .{ lastIdx, idx };
            // Skip over match
            lastIdx = idx + 1;
            idx += 1;
            idxCount += 1;
        }
        idx += 1;
    }
    // Add last part
    if (lastIdx < xs.len) {
        idxs[idxCount] = .{ lastIdx, xs.len };
        idxCount += 1;
    }
    for (0..idxCount) |i| {
        out[i] = xs[idxs[i][0]..idxs[i][1]];
    }
    return out;
}

fn mkGhosts() [3]Art {
    var out: [3]Art = .{ GHOST, GHOST, GHOST };
    out[1].col = COLS.blue;
    out[2].col = COLS.pink;
    return out;
}

inline fn join(comptime parts: []const []const u8) []const u8 {
    var all: usize = 0;
    inline for (parts) |part| {
        all += part.len;
    }
    var tmpOut: [all]u8 = undefined;
    var offset: usize = 0;
    inline for (parts) |part| {
        @memcpy(tmpOut[offset..(offset + part.len)], part);
        offset += part.len;
    }
    // Make out constant so it can be evaluated at compile time
    const out = tmpOut;
    return out[0..all];
}

// Art decl
const Art = struct {
    hasEye: bool,
    col: []const u8,
    art: [6][]const u8,
    inline fn getLn(self: @This(), comptime ln: usize) []const u8 {
        const out = self.col ++ self.art[ln];
        const isEye = switch (ln) {
            1...2 => true,
            else => false,
        };
        if (self.hasEye and isEye) {
            return self.mkEyeStr(out);
        }
        return out;
    }
    fn mkEyeStr(self: @This(), comptime str: []const u8) []const u8 {
        const parts = comptime getEyeParts(str, .{ 'C', 'R' });
        const fmtSize: usize = 9; // 5 parts + 4 colour changes
        var fmt: [fmtSize][]const u8 = undefined;
        var isCol = false;
        var isWhite = true;
        var partIdx: usize = 0;
        inline for (0..fmtSize) |i| {
            if (isCol) {
                fmt[i] = switch (isWhite) {
                    true => COLS.white,
                    false => self.col,
                };
                isWhite = !isWhite;
            } else {
                fmt[i] = parts[partIdx];
                partIdx += 1;
            }
            isCol = !isCol;
        }
        return comptime join(&fmt);
    }
};

// Artworks
const PAC = Art{
    .hasEye = false,
    .col = COLS.yellow,
    .art = .{
        "   ▄███████▄  ",
        " ▄█████████▀▀ ",
        " ███████▀     ",
        " ███████▄     ",
        " ▀█████████▄▄ ",
        "   ▀███████▀  ",
    },
};
const BALLS = Art{
    .hasEye = false,
    .col = COLS.white,
    .art = .{
        "            ",
        "            ",
        " ▄██▄  ▄██▄ ",
        " ▀██▀  ▀██▀ ",
        "            ",
        "            ",
    },
};
const GHOSTS = mkGhosts();
const GHOST = Art{
    .hasEye = true,
    .col = COLS.red,
    .art = .{
        "   ▄██████▄   ",
        " ▄C█▀█R██C█▀█R██▄ ",
        " █C▄▄█R██C▄▄█R███ ",
        " ████████████ ",
        " ██▀██▀▀██▀██ ",
        " ▀   ▀  ▀   ▀ ",
    },
};

// Colours
const Cols = struct {
    yellow: []const u8,
    red: []const u8,
    blue: []const u8,
    pink: []const u8,
    white: []const u8,
    nc: []const u8,
};

const COLS = Cols{
    .yellow = "\x1b[0;33m",
    .red = "\x1b[0;31m",
    .blue = "\x1b[0;34m",
    .pink = "\x1b[0;35m",
    .white = "\x1b[0;37m",
    .nc = "\x1b[0m",
};
