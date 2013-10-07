$ ->

    szuFmPlayer = document.getElementById("szu-fm-player");
    VOICE_FULL_WIDTH = "66px";

    # Play Button Action
    $("#btn-play").click ->
        # Instead toggle in this way
        iteration = $(this).data('iteration') || 1;
        switch iteration
            when 1
                $(this).removeClass("btn-play").addClass("btn-stop");
                szuFmPlayer.play();
                timeSpan();
            when 2
                $(this).removeClass("btn-stop").addClass("btn-play");
                szuFmPlayer.pause();

        iteration++;
        iteration = 1 if iteration > 2
        $(this).data('iteration', iteration);
        return ;


    # Rewind button
    $("#btn-rewind").click ->
        @player = document.getElementById("szu-fm-player")
        @current = @player.currentTime
        @player.currentTime = parseFloat(@current) - 1.5
        @player.play()
        return ;


    # Fast forward button
    $("#btn-ff").click ->
        @player = document.getElementById("szu-fm-player")
        @current = @player.currentTime
        @player.currentTime = parseFloat(@current) + 1.0
        @player.play()
        return ;


    # Mute button
    $("#btn-mute").click ->
        $("#volume-block").css("width", "0")
        szuFmPlayer.volume = 0
        return ;


    # Full voice button
    $("#btn-full-voice").click ->
        $("#volume-block").css("width", VOICE_FULL_WIDTH)
        szuFmPlayer.volume = 1
        return ;


    # Process bar click action
    $("#process-bar").click (e) ->
        @currentProcess = processControll(e)
        $("#process-block").css("width", @currentProcess)
        return;


    # Process block click action
    $("#process-block").click (e) ->
        @currentProcess = processControll(e)
        $("#process-block").css("width", @currentProcess)
        return;
    

    # volume bar click action
    $("#volume-bar").click (e) ->
        @currentProcess = volumeControll(e)
        $("#volume-block").css("width", currentProcess)
        return;


    # volume block click action
    $("#volume-block").click (e) ->
        @currentProcess = volumeControll(e)
        $("#volume-block").css("width", currentProcess)
        return;


    # Action for process controller
    processControll = (e) ->
        @process = $("#process-bar").offset()
        @processStart = @process.left
        @processLength = $("#process-bar").width()
        @currentProcess = e.clientX - @processStart
        durationProcessRange @currentProcess / @processLength
        return @currentProcess


    # Action for volume controller
    volumeControll = (e) ->
        @volume = $("#volume-bar").offset();
        @volumeBarStart = @volume.left;
        @volumeBarLength = $("#volume-bar").width();
        @currentProcess = e.clientX - @volumeBarStart
        volumeProcessRange @currentProcess / volumeBarLength
        return @currentProcess


    szuFmPlayer.addEventListener 'ended', ->
        console.log('called')

    return;


volumeProcessRange = (rangeVal) ->
    @player = document.getElementById("szu-fm-player")
    @player.volume = parseFloat(rangeVal)
    return ;


durationProcessRange = (rangeVal) ->
    @player = document.getElementById("szu-fm-player")
    @player.currentTime = rangeVal * @player.duration;
    @player.play()
    return ;


timeSpan = () ->
    @player = document.getElementById("szu-fm-player")
    @processBlock = 0
    setInterval(->
        @processBlock = (@player.currentTime / @player.duration) * 500
        $("#process-block").css("width", @processBlock)
        @currentTime = timeDispose(@player.currentTime)
        @timeAll = timeDispose(timeAll())
        $("#song-time").html(@currentTime + " | " + @timeAll)
    , 1000)
    return ;


timeDispose = (number) ->
    @minute = parseInt(number / 60)
    @second = parseInt(number % 60)
    @minute = "0" + @minute if @minute < 10
    @second = "0" + @second if @second < 10
    return @minute + ":" + @second


timeAll = () ->
    @player = document.getElementById("szu-fm-player")
    return @player.duration


playSong = (song) ->
    $("#btn-play").removeClass("btn-play").addClass("btn-stop");
    iteration = $("#btn-play").data('iteration') || 1;
    iteration++;
    iteration = 1 if iteration > 2
    $("#btn-play").data('iteration', iteration);
    $("#song-name").text song.title + " - " + song.artist
    @player = document.getElementById("szu-fm-player")
    @player.src = song.url
    @player.play()
    timeSpan();
    return ;


pauseSong = () ->
    @player = document.getElementById("szu-fm-player")
    $("#pause-time").val(@player.currentTime)
    @player.pause()
    return ;


continueSong = () ->
    @player = document.getElementById("szu-fm-player")
    @player.startTime = $("#pause-time").val();
    @player.play();
    return ;


exports = this
exports.playSong = playSong
exports.pauseSong = pauseSong
exports.continueSong = continueSong
